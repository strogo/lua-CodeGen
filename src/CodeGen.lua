
--
-- lua-CodeGen : <http://lua-codegen.luaforge.net/>
--

local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring = tostring
local type = type
local io = require 'io'
local table = require 'table'

module 'CodeGen'

local function render (val, sep)
    if val == nil then
        return ''
    end
    if type(val) == 'table' then
        return table.concat(val, sep)
    end
    return tostring(val)
end

local function eval (self, name)
    local function reset_messages ()
        getmetatable(self)._MSG = {}
    end  -- reset_messages

    local function get_messages ()
        local t = getmetatable(self)._MSG
        if #t > 0 then
            return table.concat(t, "\n")
        end
    end  -- get_messages

    local function interpolate (template, tname)
        if type(template) ~= 'string' then
            return nil
        end
        local lineno = 1

        local function add_message (...)
            local msg = table.concat({...})
            table.insert(getmetatable(self)._MSG, tname .. ':' .. lineno .. ': ' .. msg)
        end  -- add_message

        local function get_value (vname)
            local i = 1
            local t = self
            for w in vname:gmatch "(%w+)%." do
                i = i + w:len() + 1
                t = t[w]
                if type(t) ~= 'table' then
                    add_message(vname, " is invalid")
                    return nil
                end
            end
            return t[vname:sub(i)]
        end  -- get_value

        local function interpolate_line (line)
            local function get_repl (capt)
                local function apply (tmpl)
                    local result = interpolate(self[tmpl], tmpl)
                    if result == nil then
                        add_message(tmpl, " is not a template")
                        return capt
                    end
                    return result
                end  -- apply

                local capt1, pos = capt:match("^%${([%a_][%w%._]*)()", 1)
                if not capt1 then
                    add_message(capt, " does not match")
                    return capt
                end
                if capt:match("^}", pos) then
                    return render(get_value(capt1))
                end
                if capt:match("^%(%)}", pos) then
                    return apply(capt1)
                end
                local capt2 = capt:match("^:([%a_][%w_]*)%(%)}", pos)
                if capt2 then
                    local array = get_value(capt1)
                    if array == nil then
                        return ''
                    end
                    if type(array) ~= 'table' then
                        add_message(capt1, " is not a table")
                        return capt
                    end
                    local parents = getmetatable(self)._PARENTS
                    local results = {}
                    for i = 1, #array do
                        local elt = array[i]
                        if type(elt) ~= 'table' then
                            elt = { it = elt }
                        end
                        table.insert(parents, elt)
                        local result = apply(capt2)
                        table.insert(results, result)
                        table.remove(parents)
                        if result == capt then
                            break
                        end
                    end
                    return table.concat(results)
                end
                local capt2 = capt:match("^?([%a_][%w_]*)%(%)}", pos)
                if capt2 then
                    if get_value(capt1) then
                        return apply(capt2)
                    else
                        return ''
                    end
                end
                local capt2, capt3 = capt:match("^?([%a_][%w_]*)%(%):([%a_][%w_]*)%(%)}", pos)
                if capt2 and capt3 then
                    if get_value(capt1) then
                        return apply(capt2)
                    else
                        return apply(capt3)
                    end
                end
                local sep = capt:match("^;%s+separator%s*=%s*'([^']+)'%s*}", pos)
                if sep then
                    return render(get_value(capt1), sep)
                end
                local sep = capt:match("^;%s+separator%s*=%s*\"([^\"]+)\"%s*}", pos)
                if sep then
                    return render(get_value(capt1), sep)
                end
                add_message(capt, " does not match")
                return capt
            end  -- get_repl

            local result, nb = line:gsub("(%$%b{})", get_repl)
            return result
        end -- interpolate_line

        if template:find "\n" then
            local f = io.tmpfile()
            f:write(template)
            f:seek 'set'
            local results = {}
            for line in f:lines() do
                table.insert(results, interpolate_line(line))
                lineno = lineno + 1
            end
            table.insert(results, '')
            f:close()
            return table.concat(results, "\n")
        else
            return interpolate_line(template)
        end
    end  -- interpolate

    local val = self[name]
    if type(val) == 'string' then
        reset_messages()
        return interpolate(val, name), get_messages()
    else
        return render(val)
    end
end

local function new (class, obj)
    obj = obj or {}
    setmetatable(obj, {
        __call  = function (...) return eval(...) end,
        __index = function (t, k)
                      local parents = getmetatable(t)._PARENTS
                      for i = 1, #parents do
                          local v = parents[i][k]
                          if v ~= nil then
                              return v
                          end
                      end
                  end,
        _PARENTS = {},
    })
    return obj
end

setmetatable(_M, {
    __call = function (...) return new(...) end
})

_VERSION = "0.0.1"
_DESCRIPTION = "lua-CodeGen : a template engine"
_COPYRIGHT = "Copyright (c) 2010 Francois Perrad"
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

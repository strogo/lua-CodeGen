
--
-- lua-CodeGen : <http://lua-codegen.luaforge.net/>
--

local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring = tostring
local type = type
local table = require 'table'

module 'CodeGen'

local function eval (self, key)
    local function render (val, sep)
        if val == nil then
            return ''
        end
        if type(val) == 'table' then
            return table.concat(val, sep)
        end
        return tostring(val)
    end  -- render

    local function get_repl (capt)
        local item = capt:match "{(%w+)}"
        if item then
            return render(self[item])
        end
        local tmpl = capt:match "{(%w+)%(%)}"
        if tmpl then
            return eval(self, tmpl)
        end
        local item, tmpl = capt:match "{(%w+):(%w+)%(%)}"
        if item and tmpl then
            local array = self[item]
            if array == nil then
                return ''
            end
            local result = {}
            local parents = getmetatable(self)._PARENTS
            for i = 1, #array do
                local elt = array[i]
                if type(elt) ~= 'table' then
                    elt = { it = elt }
                end
                table.insert(parents, elt)
                table.insert(result, eval(self, tmpl))
                table.remove(parents)
            end
            return table.concat(result)
        end
        local item, sep = capt:match "{(%w+);%s+separator%s*=%s*'([^']+)'%s*}"
        if item and sep then
            return render(self[item], sep)
        end
        local item, sep = capt:match "{(%w+);%s+separator%s*=%s*\"([^\"]+)\"%s*}"
        if item then
            return render(self[item], sep)
        end
        return capt
    end  -- get_repl

    local val = self[key]
    if type(val) == 'string' then
        local str, nb = val:gsub("%$(%b{})", get_repl)
        return str
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

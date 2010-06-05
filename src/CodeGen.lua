
--
-- lua-CodeGen : <http://lua-codegen.luaforge.net/>
--

local setmetatable = setmetatable
local tostring = tostring
local type = type
local table = require 'table'

module 'CodeGen'

local function attr (self, key, sep)
    local val = self[key]
    if val == nil then
        return ''
    end
    if type(val) == 'table' then
        return table.concat(val, sep)
    else
        return tostring(val)
    end
end

local function eval (self, key)
    local function get_value (capt)
        local item = capt:match "{(%w+)}"
        if item then
            return attr(self, item)
        end
        local item = capt:match "{(%w+)%(%)}"
        if item then
            return eval(self, item)
        end
        local item, sep = capt:match "{(%w+);%s+separator%s*=%s*'([^']+)'%s*}"
        if item then
            return attr(self, item, sep)
        end
        local item, sep = capt:match "{(%w+);%s+separator%s*=%s*\"([^\"]+)\"%s*}"
        if item then
            return attr(self, item, sep)
        end
        return capt
    end  -- get_value

    local val = self[key]
    if type(val) == 'string' then
        local str, nb = val:gsub("%$(%b{})", get_value)
        return str
    else
        return attr(self, key)
    end
end

local function new (class, obj)
    obj = obj or {}
    setmetatable(obj, {
        __call = function (...) return eval(...) end
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

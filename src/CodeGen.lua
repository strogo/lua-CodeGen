
--
-- lua-CodeGen : <http://lua-codegen.luaforge.net/>
--

local setmetatable = setmetatable
local tostring = tostring
local type = type
local table = require 'table'

module 'CodeGen'

local function eval (self, key, sep)
    local val = self[key]
    if val == nil then
        return ''
    end
    local t = type(val)
    if t == 'table' then
        return table.concat(val, sep)
    elseif t == 'string' then
        local function interp (capt)
            local k = capt:sub(2, capt:len() - 1)
            return self[k]
        end
        val = val:gsub("%$(%b{})", interp)
        return val
    else
        return tostring(val)
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

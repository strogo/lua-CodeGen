
--
-- lua-CodeGen : <http://lua-codegen.luaforge.net/>
--

local error = error
local setmetatable = setmetatable
local tostring = tostring

module 'CodeGen'

local function eval (self, patt)
    local val = self[patt]
    if val == nil then
        return error("unknown: " .. patt)
    end
    return tostring(val)
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

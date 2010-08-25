
--
-- lua-CodeGen : <http://fperrad.github.com/lua-CodeGen>
--

local pairs = pairs
local table = require 'table'
local CodeGen = require 'CodeGen'

module 'CodeGen.Graph'

template = CodeGen {
    TOP = [[
digraph {
    ${nodes:_node()}

    ${edges:_edge()}
}
]],
    _node = [[
${name};
]],
    _edge = [[
${caller} -> ${callee};
]],
}

function to_dot (self)
    local done = {}
    local nodes = {}
    local edges = {}

    local function parse (name)
        if not done[name] then
            done[name] = true
            table.insert(nodes, { name = name })
            local tmpl = self[name]
            for capt in tmpl:gmatch "(%$%b{})" do
                local capt1, pos = capt:match("^%${([%a_][%w%._]*)()", 1)
                if capt1 then
                    if capt:match("^%(%)}", pos) then
                        table.insert(edges, { caller = name, callee = capt1 })
                        parse(capt1)
                    else
                        local capt2 = capt:match("^[?:]([%a_][%w_]*)%(%)}", pos)
                        if capt2 then
                            table.insert(edges, { caller = name, callee = capt2 })
                            parse(capt2)
                        else
                            local capt2, capt3 = capt:match("^?([%a_][%w_]*)%(%)!([%a_][%w_]*)%(%)}", pos)
                            if capt2 and capt3 then
                                table.insert(edges, { caller = name, callee = capt2 })
                                table.insert(edges, { caller = name, callee = capt3 })
                                parse(capt2)
                                parse(capt3)
                            end
                        end
                    end
                end
            end
        end
    end  -- parse

    for name in pairs(self[1]) do
        parse(name)
    end
    template.nodes = nodes
    template.edges = edges
    local dot = template 'TOP'
    return dot
end

--
-- Copyright (c) 2010 Francois Perrad
--
-- This library is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

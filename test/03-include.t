#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(1)

tmpl = CodeGen{
    outer = [[
begin
    ${inner()}
end
]],
    inner = [[print("${hello}");]],
    hello = "Hello, world!",
}
is( tmpl 'outer', [[
begin
    print("Hello, world!");
end
]] , "" )


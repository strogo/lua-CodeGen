#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(3)

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

tmpl.inner = 3.14
res, msg = tmpl 'outer'
is( res, [[
begin
    ${inner()}
end
]] , "not a template" )
is( msg, "inner is not a template" )

#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(5)

tmpl = CodeGen{
    code = [[print("${hello}, ${guy}");]],
    hello = "Hello",
    guy = "you",
}
is( tmpl 'code', [[print("Hello, you");]], "scalar attributes" )
tmpl.hello = "Hi"
is( tmpl 'code', [[print("Hi, you");]] )

tmpl = CodeGen()
tmpl.a = { 'abc', 'def', 'hij' }
tmpl.code = [[print(${a})]]
is( tmpl 'code', [[print(abcdefhij)]], "array" )
tmpl.code = [[print(${a; separator=', '})]]
is( tmpl 'code', [[print(abc, def, hij)]], "array with sep" )
tmpl.code = [[print(${a; separator = ", " })]]
is( tmpl 'code', [[print(abc, def, hij)]], "array with sep" )


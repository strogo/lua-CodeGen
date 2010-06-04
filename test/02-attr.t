#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(4)

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
is( tmpl 'a', 'abcdefhij', "eval array" )
is( tmpl('a', ';'), 'abc;def;hij', "with sep" )


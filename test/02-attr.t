#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(8)

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

tmpl = CodeGen{
    code = [[print("${data.hello}, ${data.people.guy}");]],
    data = {
        hello = "Hello",
        people = {
            guy = "you",
        },
    },
}
is( tmpl 'code', [[print("Hello, you");]], "complex attr" )
tmpl.data.hello = "Hi"
is( tmpl 'code', [[print("Hi, you");]] )

tmpl.code = [[print("${hello}, ${people.guy}");]]
is( tmpl 'code', [[print(", ");]], "missing attr" )

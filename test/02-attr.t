#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(13)

tmpl = CodeGen{
    code = [[print("${hello}, ${_guy1}");]],
    hello = "Hello",
    _guy1 = "you",
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
res, msg = tmpl 'code'
is( res, [[print(", ");]], "missing attr" )
is( msg, "code:1: people.guy is invalid" )

tmpl.code = [[print("${hello-people}");]]
res, msg = tmpl 'code'
is( res, [[print("${hello-people}");]], "no match" )
is( msg, "code:1: ${hello-people} does not match" )

tmpl.code = [[print("${ hello }");]]
res, msg = tmpl 'code'
is( res, [[print("${ hello }");]], "no match" )
is( msg, "code:1: ${ hello } does not match" )


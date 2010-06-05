#!/usr/bin/env lua

require 'CodeGen'

require 'Test.More'

plan(3)

tmpl = CodeGen{
    outer = [[
begin
${data:inner()}
end
]],
    inner = [[print("${name} = ${value}");]],
}
is( tmpl 'outer', [[
begin

end
]] , "empty" )

tmpl.data = {
    { name = 'key1', value = 1 },
    { name = 'key2', value = 2 },
    { name = 'key3', value = 3 },
}
is( tmpl 'outer', [[
begin
print("key1 = 1");print("key2 = 2");print("key3 = 3");
end
]] , "with array" )

tmpl = CodeGen{
    outer = [[
begin
${data:inner()}
end
]],
    inner = [[print(${it});]],
}
tmpl.data = { 1, 2, 3 }
is( tmpl 'outer', [[
begin
print(1);print(2);print(3);
end
]] , "it" )



lua-Code : a template engine
============================

Introduction
------------

lua-CodeGen is a "safe" template engine.

lua-CodeGen enforces a strict Model-View separation.
Only 4 primitives are supplied :

- attribute reference,
- template include, 
- conditional include 
- and template application (i.e., _map_ operation).

lua-CodeGen allows to split template in small chunk,
and encourages the reuse of them by inheritance.

Each chunk of template is like a rule of a grammar
for an _unparser generator_.

lua-CodeGen is not dedicated to HTML,
it could generate any kind of textual code.


References
----------

the Terence Parr's papers :

+ [Enforcing Strict Model-View Separation in Template Engines](http://www.cs.usfca.edu/~parrt/papers/mvc.templates.pdf)
+ [A Functional Language For Generating Structured Text](http://www.cs.usfca.edu/~parrt/papers/ST.pdf)

Links
-----

The homepage is at [http://fperrad.github.com/lua-CodeGen](http://fperrad.github.com/lua-CodeGen),
and the sources are hosted at [http://github.com/fperrad/lua-CodeGen](http://github.com/fperrad/lua-CodeGen).

Copyright and License
---------------------

Copyright (c) 2010 Francois Perrad

This library is licensed under the terms of the MIT/X11 license, like Lua itself.


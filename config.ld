-- Configuration for LDoc
-- See https://stevedonovan.github.io/ldoc/manual/doc.md.html

project = "Virtual Schema Common Lua"
description = [[# Common base library for Virtual Schemas written in Lua that run on Exasol

Please visit the [project homepage on GitHub](https://github.com/exasol/virtual-schema-common-lua) for detailed information.
]]
title = "Reference"
file = {"./src/"}
--examples = {"./doc/user_guide/examples.lua"}
package = "."
format = "markdown"
output = "index"
dir = "./target/ldoc"
colon = false
boilerplate = false -- ignore first comment
ext = "html"
one = false -- one column style
pretty = "lua" -- code prettifier
prettify_files = true
charset = "UTF-8"
sort = false
backtick_references = false
wrap = true
no_space_before_args = true
all = true -- show also local functions

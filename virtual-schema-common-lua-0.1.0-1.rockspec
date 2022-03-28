rockspec_format = "3.0"

package = "virtual-schema-common-lua"
version = "0.1.0-1"

source = {
    url = 'git://github.com/exasol/virtual-schema-common-lua',
    tag = "0.1.0"
}

description = {
    summary = "Base library for Lua-powered Exasol Virtual Schemas",
    detailed = [[This project contains a base library that abstracts Exasol's Virtual Schema API
    (https://github.com/exasol/virtual-schema-common-java/blob/main/doc/development/api/virtual_schema_api.md)
    and provides a convenient starting point for implementing Lua-based Virtual Schemas.]],
    homepage = "https://github.com/exasol/virtual-schema-common-lua",
    license = "MIT",
    maintainer = 'Exasol <opensource@exasol.com>'
}

dependencies = {
    "lua >= 5.4, < 5.5",
    "exaerror >= 1.2.2",
    "lua-cjson = 2.1.0", -- pinned to prevent "undefined symbol: lua_objlen" in 2.1.0.6
    "remotelog >= 1.1.1"
}

build_dependencies = {
    "busted >= 2.0.0",
    "luacheck >= 0.25.0",
    "luacov >= 0.15.0",
    "luacov-coveralls >= 0.2.3"
}

build = {
    type = "builtin",
    modules = {
        ["exasolvs.AdapterProperties"] = "src/exasolvs/AdapterProperties.lua",
        ["exasolvs.AbstractVirtualSchemaAdapter"] = "src/exasolvs/AbstractVirtualSchemaAdapter.lua",
        ["exasolvs.QueryRenderer"] = "src/exasolvs/QueryRenderer.lua",
        ["exasolvs.RequestDispatcher"] = "src/exasolvs/RequestDispatcher.lua",
        ["text"] = "src/text.lua"
    },
    copy_directories = { "doc", "spec" }
}
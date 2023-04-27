rockspec_format = "3.0"

local tag = "3.1.0"

package = "virtual-schema-common-lua"
version = tag .. "-1"

source = {
    url = 'git://github.com/exasol/virtual-schema-common-lua',
    tag = tag
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
    "exaerror >= 2.0.3",
    "lua-cjson = 2.1.0", -- pinned to prevent "undefined symbol: lua_objlen" in 2.1.0.6 (https://github.com/mpx/lua-cjson/issues/56)
    "remotelog >= 1.1.1"
}

test_dependencies = {
    "busted >= 2.0.0",
    "luacheck >= 0.25.0",
    "luacov >= 0.15.0",
    "luacov-coveralls >= 0.2.3",
    "ldoc >= 1.4.6-2"
}

test = {
    type = "busted"
}

build = {
    type = "builtin",
    modules = {
        ["exasol.validator"] = "src/exasol/validator.lua",
        ["exasol.vsclAdapterProperties"] = "src/exasolvs/AdapterProperties.lua",
        ["exasol.vsclAbstractVirtualSchemaAdapter"] = "src/exasolvs/AbstractVirtualSchemaAdapter.lua",
        ["exasol.vsclImportQueryBuilder"] = "src/exasolvs/ImportQueryBuilder.lua",
        ["exasol.vsclQuery"] = "src/exasolvs/Query.lua",
        ["exasol.vsclQueryRenderer"] = "src/exasolvs/QueryRenderer.lua",
        ["exasol.vsclqueryrenderer.AbstractQueryAppender"] = "src/exasolvs/queryrenderer/AbstractQueryAppender.lua",
        ["exasol.vsclqueryrenderer.ExpressionAppender"] = "src/exasolvs/queryrenderer/ExpressionAppender.lua",
        ["exasol.vsclqueryrenderer.ScalarFunctionAppender"] = "src/exasolvs/queryrenderer/ScalarFunctionAppender.lua",
        ["exasol.vsclqueryrenderer.AggregateFunctionAppender"] = "src/exasolvs/queryrenderer/AggregateFunctionAppender.lua",
        ["exasol.vsclqueryrenderer.SelectAppender"] = "src/exasolvs/queryrenderer/SelectAppender.lua",
        ["exasol.vsclqueryrenderer.ImportAppender"] = "src/exasolvs/queryrenderer/ImportAppender.lua",
        ["exasol.vsclRequestDispatcher"] = "src/exasolvs/RequestDispatcher.lua",
        ["text"] = "src/text.lua"
    },
    copy_directories = { "doc"}
}
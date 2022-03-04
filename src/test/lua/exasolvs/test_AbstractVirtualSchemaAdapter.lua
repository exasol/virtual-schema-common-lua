local luaunit = require("luaunit")
local AbstractVirtualSchemaAdapter = require("exasolvs/AbstractVirtualSchemaAdapter")

test_AbstractVirtualSchemaAdapter = {}

function test_AbstractVirtualSchemaAdapter.test_get_capabilities()
    local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2"} end}
    local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
    luaunit.assertEquals(vs_adapter:get_capabilities(), {type = "getCapabilities", capabilities={"cap1", "cap2"}})
end

function test_AbstractVirtualSchemaAdapter.test_exclude_capabilities()
    local request_stub = {
        schemaMetadataInfo = {
            properties = {EXCLUDED_CAPABILITIES = "cap1, cap3"}
        }
    }
    local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2", "cap3", "cap4"} end}
    local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
    luaunit.assertEquals(vs_adapter:get_capabilities(nil, request_stub),
             {type = "getCapabilities", capabilities={"cap2", "cap4"}})
end

function test_AbstractVirtualSchemaAdapter.test_drop_virtual_schema()
    local vs_adapter = AbstractVirtualSchemaAdapter:new()
    luaunit.assertEquals(vs_adapter:drop_virtual_schema(), {type="dropVirtualSchema"})
end

function test_AbstractVirtualSchemaAdapter.test_get_name_is_abstract()
    luaunit.assertError("Method 'AbstractVirtualSchemaAdapter:get_name' is abstract.",
            AbstractVirtualSchemaAdapter.get_name)
end

function test_AbstractVirtualSchemaAdapter.test_get_version_is_abstract()
    luaunit.assertError("Method 'AbstractVirtualSchemaAdapter:get_version' is abstract.",
            AbstractVirtualSchemaAdapter.get_version)
end

function test_AbstractVirtualSchemaAdapter.test_define_capabilities_is_abstract()
    luaunit.assertError("Method 'AbstractVirtualSchemaAdapter:define_capabilities' is abstract.",
            AbstractVirtualSchemaAdapter._define_capabilities)
end

os.exit(luaunit.LuaUnit.run())
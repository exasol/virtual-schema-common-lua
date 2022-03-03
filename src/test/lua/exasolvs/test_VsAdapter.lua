local luaunit = require("luaunit")
local VsAdapter = require("exasolvs/VsAdapter")

test_VsAdapter = {}

function test_VsAdapter.test_get_capabilities()
    local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2"} end}
    local vs_adapter = VsAdapter:new(adapter_stub)
    luaunit.assertEquals(vs_adapter:get_capabilities(), {type = "getCapabilities", capabilities={"cap1", "cap2"}})
end

function test_VsAdapter.test_exclude_capabilities()
    local request_stub = {
        schemaMetadataInfo = {
            properties = {EXCLUDED_CAPABILITIES = "cap1, cap3"}
        }
    }
    local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2", "cap3", "cap4"} end}
    local vs_adapter = VsAdapter:new(adapter_stub)
    luaunit.assertEquals(vs_adapter:get_capabilities(nil, request_stub),
             {type = "getCapabilities", capabilities={"cap2", "cap4"}})
end

function test_VsAdapter.test_drop_virtual_schema()
    local vs_adapter = VsAdapter:new()
    luaunit.assertEquals(vs_adapter:drop_virtual_schema(), {type="dropVirtualSchema"})
end

function test_VsAdapter.test_get_name_is_abstract()
    luaunit.assertError("Method 'VsAdapter:get_name' is abstract.", VsAdapter.get_name)
end

function test_VsAdapter.test_get_version_is_abstract()
    luaunit.assertError("Method 'VsAdapter:get_version' is abstract.", VsAdapter.get_version)
end

function test_VsAdapter.test_define_capabilities_is_abstract()
    luaunit.assertError("Method 'VsAdapter:define_capabilities' is abstract.", VsAdapter._define_capabilities)
end

os.exit(luaunit.LuaUnit.run())
require("busted.runner")()
package.path = "../src/?.lua;" .. package.path
require("assertions.assertions")
local AbstractVirtualSchemaAdapter = require("exasolvs/AbstractVirtualSchemaAdapter")

describe("Stubbed AbstractVirtualSchemaAdapter", function()
    it("reports all supported capabilities", function()
        local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2"} end}
        local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
        assert.are.same(vs_adapter:get_capabilities(), {type = "getCapabilities", capabilities={"cap1", "cap2"}})
    end)

    it("reports all capabilities except the ones the user excluded", function()
        local request_stub = {
            schemaMetadataInfo = {
                properties = {EXCLUDED_CAPABILITIES = "cap1, cap3"}
            }
        }
        local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2", "cap3", "cap4"} end}
        local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
        assert.are.same(vs_adapter:get_capabilities(nil, request_stub),
                {type = "getCapabilities", capabilities={"cap2", "cap4"}})
    end)

    it("has a basic DROP SCHEMA handler (which does nothing)", function()
        local vs_adapter = AbstractVirtualSchemaAdapter:new()
        assert.are.same(vs_adapter:drop_virtual_schema(), {type="dropVirtualSchema"})
    end)

    it("is an abstract class", function()
        assert.is.abstract_method(AbstractVirtualSchemaAdapter.get_name)
        assert.is.abstract_method(AbstractVirtualSchemaAdapter.get_version)
        assert.is.abstract_method(AbstractVirtualSchemaAdapter._define_capabilities)
    end)
end)
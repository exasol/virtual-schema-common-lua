require("busted.runner")()
require("spec.assertions.assertions")
local AbstractVirtualSchemaAdapter = require("exasolvs.AbstractVirtualSchemaAdapter")
local AdapterProperties = require("exasolvs.AdapterProperties")

describe("Stubbed AbstractVirtualSchemaAdapter", function()
    it("reports all supported capabilities", function()
        local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2"} end}
        local properties = AdapterProperties:new()
        local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
        assert.are.same(vs_adapter:get_capabilities(nil, properties),
                {type = "getCapabilities", capabilities={"cap1", "cap2"}})
    end)

    it("reports all capabilities except the ones the user excluded", function()
        local properties = AdapterProperties.create({EXCLUDED_CAPABILITIES = "cap1, cap3"})
        local adapter_stub = {_define_capabilities = function () return {"cap1", "cap2", "cap3", "cap4"} end}
        local vs_adapter = AbstractVirtualSchemaAdapter:new(adapter_stub)
        assert.are.same(vs_adapter:get_capabilities(nil, properties),
                {type = "getCapabilities", capabilities={"cap2", "cap4"}})
    end)

    it("has a basic DROP SCHEMA handler (which does nothing)", function()
        local vs_adapter = AbstractVirtualSchemaAdapter:new()
        assert.are.same(vs_adapter:drop_virtual_schema(), {type="dropVirtualSchema"})
    end)

    describe("is an abstract class with abstract method:", function()
        local names = {"_define_capabilities", "create_virtual_schema", "get_name", "get_version", "refresh",
                       "set_properties", "push_down"}
        for _, name in ipairs(names) do
            it(name, function()
                assert.is_not_nil(AbstractVirtualSchemaAdapter[name])
                assert.is.abstract_method(AbstractVirtualSchemaAdapter[name])
            end)
        end
    end)
end)
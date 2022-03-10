require("busted.runner")
local cjson = require("cjson")
local RequestDispatcher = require("exasolvs.RequestDispatcher")
local AbstractVirtualSchemaAdapater = require("exasolvs.AbstractVirtualSchemaAdapter")

local function stub_adapter()
    return AbstractVirtualSchemaAdapter:new({
        get_name = function () return "Adapter Stub" end,
        get_version = function () return "0.0.0" end,
        _define_capabilities = function () return {} end
    })
end

local dispatcher = RequestDispatcher.create(stub_adapter())

local function same_json(state, arguments)
    local expected = arguments[1]
    return function(value)
        return assert.are.equal(expected, cjson.decode(value))
    end
end

assert:register("assertion", "same_json", same_json,
    say:set("assertion.same_json.positive", "Expected $s\nto be JSON structure that matches: %s"),
    say:set("assertion.same_json.positive", "Expected $s\nto be JSON structure that differs from: %s")
)

describe("RequestDispatcher", function()
    it("gets adapter capabilities",function()
        local response = dispatcher:adapter_call('{"{"type" : "getCapabilities"}')
        local expected = {type = "getCapabilities", capabilities = {}}
        assert.is.same_json(expected, response)
    end)

end)


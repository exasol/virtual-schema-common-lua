package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local log_mock = mock(require("remotelog"), true)
package.preload["remotelog"] = function () return log_mock end
require("assertions.assertions")
local RequestDispatcher = require("exasolvs.RequestDispatcher")
local AbstractVirtualSchemaAdapter = require("exasolvs.AbstractVirtualSchemaAdapter")

local function stub_adapter()
    return AbstractVirtualSchemaAdapter:new({
        get_name = function () return "Adapter Stub" end,
        get_version = function () return "0.0.0" end,
        _define_capabilities = function () return {} end
    })
end

local dispatcher = RequestDispatcher.create(stub_adapter())

describe("RequestDispatcher", function()
    it("asserts that a virtual schema adapter is present", function()
        assert.error_contains(function() RequestDispatcher:new() end,
                "Request Dispatcher requires an adapter to dispatch too")
    end)

    it("dispatches get-capabilities request",function()
        local response = dispatcher:adapter_call('{"type" : "getCapabilities"}')
        local expected = {type = "getCapabilities", capabilities = {}}
        assert.is.same_json(expected, response)
    end)

    it("sets up remote logging", function()
        dispatcher:adapter_call('{"type" : "getCapabilities", "schemaMetadataInfo" : '
                .. '{"properties" : {"DEBUG_ADDRESS" : "10.0.0.1:4000", "LOG_LEVEL" : "TRACE"}}}')
        assert.spy(log_mock.set_level).was.called_with("TRACE")
        assert.spy(log_mock.connect).was.called_with("10.0.0.1", 4000)
    end)

    local function call_with_illegal_request_type()
         dispatcher:adapter_call('{"type" : "illegal"}')
    end

    it("raises an error if it detects an illegal Virtual Schema request type", function()
        assert.error_contains(call_with_illegal_request_type, "Unknown Virtual Schema request type 'illegal' received.")
    end)

    it("wraps caught errors to log them",function()
        assert.has_error(call_with_illegal_request_type)
        assert.spy(log_mock.fatal).was.called_with(
                [[F-RQD-1: Unknown Virtual Schema request type 'illegal' received.

Mitigations:

* This is an internal software error. Please report it via the project's ticket tracker.]])
    end)

    it("works around the (x)pcall problem in https://github.com/exasol/virtual-schema-common-lua/issues/9", function()
        local original_pcall = _G.pcall
        local recorded_message
        local record_message = function (message)  recorded_message = message end
        _G.pcall = function() return false, "not what you expect" end
        xpcall(call_with_illegal_request_type, record_message)
        _G.pcall= original_pcall
        assert.match("Unknown Virtual Schema request", recorded_message, 1, true)
    end)
end)
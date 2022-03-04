local luaunit = require("luaunit")
local mockagne = require("mockagne")
local log_mock = mockagne.getMock()
package.preload["remotelog"] = function () return log_mock end
local cjson = require("cjson")
local verify = mockagne.verify
local AbstractVirtualSchemaAdapter = require("exasolvs.AbstractVirtualSchemaAdapter")
local RequestDispatcher = require("exasolvs.RequestDispatcher")

local function stub_adapter()
    return AbstractVirtualSchemaAdapter:new({
        get_name = function () return "Adapter Stub" end,
        get_version = function () return "0.0.0" end,
        _define_capabilities = function () return {} end
    })
end

local dispatcher = RequestDispatcher.create(stub_adapter())

test_request_dispatcher = {}

local function json_assert(actual, expected)
    luaunit.assertEquals(cjson.decode(actual), expected)
end

function test_request_dispatcher.test_get_capabilities()
    local response = dispatcher:adapter_call('{"type" : "getCapabilities"}')
    local expected = {type = "getCapabilities", capabilities = {}}
    json_assert(response, expected)
end

function test_request_dispatcher.test_setup_remote_logging()
    dispatcher:adapter_call('{"type" : "getCapabilities", "schemaMetadataInfo" : '
        .. '{"properties" : {"DEBUG_ADDRESS" : "10.0.0.1:4000", "LOG_LEVEL" : "TRACE"}}}')
    verify(log_mock.set_level("TRACE"))
    verify(log_mock.connect("10.0.0.1", "4000"))
end

function test_request_dispatcher.test_unknown_request_type_raises_error()
    luaunit.assertErrorMsgContains("Unknown Virtual Schema request type 'illegal' received.",
          dispatcher.adapter_call, dispatcher, '{"type" : "illegal"}')
end

function test_request_dispatcher.test_error_wrapping()
    luaunit.assertErrorMsgContains("Unknown Virtual Schema request type 'illegalRequest' received",
         dispatcher.adapter_call, dispatcher, '{"type" : "illegalRequest"}')
    verify(log_mock.fatal([[F-RQD-1: Unknown Virtual Schema request type 'illegalRequest' received.

Mitigations:

* This is an internal software error. Please report it via the project's ticket tracker.]]))
end

os.exit(luaunit.LuaUnit.run())

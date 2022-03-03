local log = require("remotelog")
local cjson = require("cjson")
local exaerror = require("exaerror")

---
-- @module exasolvs.request_dispatcher
--
-- This class dispatches Virtual Schema requests to a Virtual Schema adapter.
-- <p>
-- It is independent of the use case of the VS adapter and offers functionality that each Virtual Schema needs, like
-- JSON decoding and encoding and setting up remote logging.
-- </p>
-- <p>
-- To use the dispatcher, you need to inject the concrete adapter the dispatcher should send the prepared requests to.
-- </p>
--
local RequestDispatcher = {
    TRUNCATE_ERRORS_AFTER = 3000
}

---
-- Create a new <code>RequestDispatcher</code>.
--
-- @return dispatcher instance
--
function RequestDispatcher:new(self, object)
    local object = object or {}
    self.__index=self
    setmetatable(object, self)
    return object
end

---
-- Inject the adapter that the dispatcher should dispatch requests to.
--
-- @param adapter adapter that receives the dispatched requests
--
-- @return this module for fluent programming
--
function RequestDispatcher.create(adapter)
    local dispatcher = RequestDispatcher:new({adapter=adapter})
    return dispatcher
end


local function handle_request(self, request)
    local handlers = {
        pushdown =  self.adapter.push_down,
        createVirtualSchema = self.adapter.create_virtual_schema,
        dropVirtualSchema = self.adapter.drop_virtual_schema,
        refresh = self.adapter.refresh,
        getCapabilities = self.adapter.get_capabilities,
        setProperties = self.adapter.set_properties
    }
    log.info('Received "%s" request.', request.type)
    local handler = handlers[request.type]
    if(handler ~= nil) then
        local response = cjson.encode(handler(self.adapter, nil, request))
        log.debug("Response:\n" .. response)
        return response
    else
        exaerror.create("F-RQD-1", "Unknown Virtual Schema request type {{request_type}} received.",
            {request_type = request.type})
            :add_ticket_mitigation()
            :raise(0)
    end
end

local function log_error(message)
    log.debug("Error handler called")
    local error_type = string.sub(message, 1, 2)
    if(error_type == "F-") then
        log.fatal(message)
    else
        log.error(message)
    end
end

local function handle_error(message)
    if(string.len(message) > RequestDispatcher.TRUNCATE_ERRORS_AFTER) then
        message = string.sub(message, 1, RequestDispatcher.TRUNCATE_ERRORS_AFTER) ..
            "\n... (error message truncated after " .. RequestDispatcher.TRUNCATE_ERRORS_AFTER .. " characters)"
    end
    log_error(message)
    return message 
end

---
-- RLS adapter entry point.
-- <p>
-- This global function receives the request from the Exasol core database.
-- </p>
--
-- @param request_as_json JSON-encoded adapter request
--
-- @return JSON-encoded adapter response
--
function RequestDispatcher:adapter_call(request_as_json)
    log.set_client_name(self.adapter:get_name() .. " " .. self.adapter:get_version())
    local request = cjson.decode(request_as_json)
    local properties = (request.schemaMetadataInfo or {}).properties or {}
    local log_level = properties.LOG_LEVEL
    if(log_level) then
        log.set_level(string.upper(log_level))
    end
    local debug_address = properties.DEBUG_ADDRESS
    if(debug_address) then
        local colon_position = string.find(debug_address,":", 1, true)
        local host = string.sub(debug_address, 1, colon_position - 1)
        local port = string.sub(debug_address, colon_position + 1)
        log.connect(host, port)
    end
    log.debug("Raw request:\n%s", request_as_json)
    local ok, result = xpcall(function () return handle_request(self, request) end, handle_error)
    if(ok) then
        log.disconnect()
        return result
    else
        log.disconnect()
        error(result)
    end
end

return RequestDispatcher

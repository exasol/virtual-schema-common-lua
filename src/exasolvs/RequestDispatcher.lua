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
-- Inject the adapter that the dispatcher should dispatch requests to.
--
-- @param adapter adapter that receives the dispatched requests
-- @param properties_reader properties reader
--
-- @return this module for fluent programming
--
function RequestDispatcher.create(adapter, properties_reader)
    return RequestDispatcher:new({adapter = adapter, properties_reader = properties_reader})
end

---
-- Create a new <code>RequestDispatcher</code>.
--
-- @return dispatcher instance
--
function RequestDispatcher:new(object)
    object = object or {}
    assert(object.adapter ~= nil, "Request Dispatcher requires an adapter to dispatch too")
    object.properties_reader = object.properties_reader or require("exasolvs.AdapterProperties")
    self.__index = self
    setmetatable(object, self)
    return object
end

-- [impl -> dsn~dispatching-push-down-requests~0]
-- [impl -> dsn~dispatching-create-virtual-schema-requests~0]
-- [impl -> dsn~dispatching-drop-virtual-schema-requests~0]
-- [impl -> dsn~dispatching-refresh-requests~0]
-- [impl -> dsn~dispatching-get-capabilities-requests~0]
-- [impl -> dsn~dispatching-set-properties-requests~0]
function RequestDispatcher:_handle_request(request, properties)
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
        local response = cjson.encode(handler(self.adapter, request, properties))
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

function RequestDispatcher:_extract_properties(request)
    local raw_properties = (request.schemaMetadataInfo or {}).properties or {}
    return self.properties_reader.create(raw_properties)
end

function RequestDispatcher:_init_logging(properties)
    log.set_client_name(self.adapter:get_name() .. " " .. self.adapter:get_version())
    if properties:has_log_level() then
        log.set_level(string.upper(properties:get_log_level()))
    end
    local host, port = properties:get_debug_address()
    if host then
        log.connect(host, port)
    end
end

-- https://github.com/exasol/virtual-schema-common-lua/issues/9
local function xpcall_workaround(callback, error_handler, ...)
    local probe <const> = "PROBE:error"
    local _, actual = pcall(function() error(probe, 0) end)
    if(actual == probe) then
        return xpcall(callback, error_handler, ...)
    else
        log.trace("This version of Exasol has a problem with (x)pcall. Applying workaround.")
        return true, callback(...)
    end
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
    local request = cjson.decode(request_as_json)
    local properties = self:_extract_properties(request)
    self:_init_logging(properties)
    log.debug("Raw request:\n%s", request_as_json)
    local ok, result = xpcall_workaround(RequestDispatcher._handle_request, handle_error, self, request, properties)
    if ok then
        log.disconnect()
        return result
    else
        log.disconnect()
        error(result)
    end
end

return RequestDispatcher
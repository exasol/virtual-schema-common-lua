local log = require("remotelog")
local cjson = require("cjson")
local exaerror = require("exaerror")

--- This class dispatches Virtual Schema requests to a Virtual Schema adapter.
-- It is independent of the use case of the VS adapter and offers functionality that each Virtual Schema needs, like
-- JSON decoding and encoding and setting up remote logging.
-- To use the dispatcher, you need to inject the concrete adapter the dispatcher should send the prepared requests to.
-- @classmod RequestDispatcher
local RequestDispatcher = {}
RequestDispatcher.__index = RequestDispatcher
local TRUNCATE_ERRORS_AFTER <const> = 3000

--- Create a new <code>RequestDispatcher</code>.
-- @param adapter adapter that receives the dispatched requests
-- @param properties_reader properties reader
-- @return dispatcher instance
function RequestDispatcher:new(adapter, properties_reader)
    assert(adapter ~= nil, "Request Dispatcher requires an adapter to dispatch too")
    local instance = setmetatable({}, self)
    instance:_init(adapter, properties_reader)
    return instance
end

function RequestDispatcher:_init(adapter, properties_reader)
    self.adapter = adapter
    self.properties_reader = properties_reader or require("exasolvs.AdapterProperties")
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
        return handler(self.adapter, request, properties)
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
    if error_type == "F-" then
        log.fatal(message)
    else
        log.error(message)
    end
end

local function handle_error(message)
    if string.len(message) > TRUNCATE_ERRORS_AFTER then
        message = string.sub(message, 1, TRUNCATE_ERRORS_AFTER) ..
            "\n... (error message truncated after " .. TRUNCATE_ERRORS_AFTER .. " characters)"
    end
    log_error(message)
    return message
end

-- [impl -> dsn~reading-user-defined-properties~0]
function RequestDispatcher:_extract_properties(request)
    local raw_properties = (request.schemaMetadataInfo or {}).properties or {}
    return self.properties_reader:new(raw_properties)
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
-- [impl -> dsn~translating-json-request-to-lua-tables~0]
-- [impl -> dsn~translating-lua-tables-to-json-responses~0]
function RequestDispatcher:adapter_call(request_as_json)
    local request = cjson.decode(request_as_json)
    local properties = self:_extract_properties(request)
    self:_init_logging(properties)
    log.debug("Raw request:\n%s", request_as_json)
    local ok, result = xpcall(RequestDispatcher._handle_request, handle_error, self, request, properties)
    if ok then
        local response = cjson.encode(result)
        log.debug("Response:\n" .. response)
        log.disconnect()
        return response
    else
        log.disconnect()
        error(result)
    end
end

return RequestDispatcher
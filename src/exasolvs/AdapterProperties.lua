local text = require("text")
local exaerror = require("exaerror")

--- This class abstracts access to the user-defined properties of the Virtual Schema.
-- @classmod AdapterProperties
local AdapterProperties = {}
AdapterProperties.__index = AdapterProperties

local EXCLUDED_CAPABILITIES_PROPERTY <const> = "EXCLUDED_CAPABILITIES"
local LOG_LEVEL_PROPERTY <const> = "LOG_LEVEL"
local DEBUG_ADDRESS_PROPERTY <const> = "DEBUG_ADDRESS"
local DEFAULT_LOG_PORT <const> = 3000

--- Create a new instance of adapter properties.
-- @param raw_properties properties as key-value pairs
-- @return new instance
function AdapterProperties:new (raw_properties)
    local instance = setmetatable({}, self)
    instance:_init(raw_properties)
    return instance
end

function AdapterProperties:_init(raw_properties)
    self._raw_properties = raw_properties
end

--- Get the value of a property.
-- @param property_name name of the property to get
-- @return property value
function AdapterProperties:get(property_name)
    return self._raw_properties[property_name]
end

--- Check if the property is set.
-- @param property_name name of the property to check
-- @return `true` if the property is set (i.e. not `nil`)
function AdapterProperties:is_property_set(property_name)
    return self:get(property_name) ~= nil
end

--- Check if the property has a non-empty value.
-- @param property_name name of the property to check
-- @return `true` if the property has a non-empty value (i.e. not `nil` or an empty string)
function AdapterProperties:has_value(property_name)
    local value = self:get(property_name)
    return value ~= nil and value ~= ""
end

--- Check if the property value is empty.
-- @param property_name name of the property to check
-- @return `true` if the property's value is empty (i.e. the property is set to an empty string)
function AdapterProperties:is_empty(property_name)
    return self:get(property_name) == ""
end

function AdapterProperties:_validate_debug_address()
    if self:has_value(DEBUG_ADDRESS_PROPERTY) then
        local address = self:get(DEBUG_ADDRESS_PROPERTY)
        if not string.match(address, "^.-:[0-9]+$") then
            exaerror.create("F-VSCL-PROP-3", "Expected log address in " .. DEBUG_ADDRESS_PROPERTY
                    .. " to look like '<ip>|<host>[:<port>]', but got {{address}} instead"
                    , {address = address})
                    :add_mitigations("Provide an valid IP address or host name")
                    :add_mitigations("Make sure host/ip and port number are separated by a colon")
                    :add_mitigations("Optionally add a port number (default is 3000)")
                    :add_mitigations("Don't add any whitespace characters")
                    :raise()
        end
    end
end

function AdapterProperties:_validate_log_level()
    if self:has_value(LOG_LEVEL_PROPERTY) then
        local level = self:get_log_level()
        local allowed_levels = {"FATAL", "ERROR", "WARNING", "INFO", "CONFIG", "DEBUG", "TRACE"}
        local found = false
        for _, allowed in ipairs(allowed_levels) do
            if level == allowed then
                found = true
                break
            end
        end
        if not found then
            exaerror.create("F-VSCL-PROP-2", "Unknown log level {{level}} in " .. LOG_LEVEL_PROPERTY .. " property",
                    {level = level})
                    :add_mitigations("Pick one of: " .. table.concat(allowed_levels, ", "))
                    :raise()
        end
    end
end

function AdapterProperties:_validate_excluded_capabilities()
    if self:has_value(EXCLUDED_CAPABILITIES_PROPERTY) then
        local value = self:get(EXCLUDED_CAPABILITIES_PROPERTY)
        if not string.match(value, "^[ A-Za-z0-9_,]*$") then
            exaerror.create("F-VSCL-PROP-1", "Invalid character(s) in " .. EXCLUDED_CAPABILITIES_PROPERTY
                    .. " property: {{value}}", {value = value})
                    :add_mitigations("Use only the following characters: ASCII letter, digit, underscore, comma, space")
                    :raise()
        end
    end
end

--- Validate the adapter properties.
-- @raise validation error
function AdapterProperties:validate()
    self:_validate_debug_address()
    self:_validate_log_level()
    self:_validate_excluded_capabilities()
end

--- Get the log level
-- @return log level
function AdapterProperties:get_log_level()
    return self:get(LOG_LEVEL_PROPERTY)
end

--- Check if the log level is set
-- @return `true` if the log level is set
function AdapterProperties:has_log_level()
    return self:has_value(LOG_LEVEL_PROPERTY)
end

--- Get the list of names of the excluded capabilities.
-- @return excluded capabilities
function AdapterProperties:get_excluded_capabilities()
    return text.split(self:get(EXCLUDED_CAPABILITIES_PROPERTY))
end

--- Check if excluded capabilities are set
-- @return `true` if the excluded capabilities are set
function AdapterProperties:has_excluded_capabilities()
    return self:has_value(EXCLUDED_CAPABILITIES_PROPERTY)
end

--- Get the debug address (host and port)
-- @return host, port or nil if the property has no value
function AdapterProperties:get_debug_address()
    if self:has_value(DEBUG_ADDRESS_PROPERTY) then
        local debug_address = self:get(DEBUG_ADDRESS_PROPERTY)
        local colon_position = string.find(debug_address,":", 1, true)
        if colon_position == nil then
            return debug_address, DEFAULT_LOG_PORT
        else
            local host = string.sub(debug_address, 1, colon_position - 1)
            local port = tonumber(string.sub(debug_address, colon_position + 1))
            return host, port
        end
    else
        return nil, nil
    end
end

--- Check if log address set
-- @return `true` if the log address is set
function AdapterProperties:has_debug_address()
    return self:has_value(DEBUG_ADDRESS_PROPERTY)
end

return AdapterProperties
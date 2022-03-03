local text = require("text")

---
-- @module exasolvs.VsAdapter
--
-- This module implements an abstract base adapter with common behavior for some of the request callback functions.
-- <p>
-- When you derive a concrete adapter from this base class, we recommend keeping it stateless. This makes
-- parallelization easier, reduces complexity and saves you the trouble of cleaning up in the drop-virtual-schema
-- request.
-- </p>
--
local VsAdapter = {
}

---
-- Get the adapter name
-- 
-- @return adapter name
-- 
function VsAdapter:get_name()
    error("Method 'VsAdapter:get_name' is abstract.")
end 

---
-- Get the adapter version
-- 
-- @return version of the adapter
-- 
function VsAdapter:get_version()
    error("Method 'VsAdapter:get_version' is abstract.")
end 

---
-- Define the list of all capabilities this adapter supports.
-- <p>
-- Override this method in derived adapter class. Note that this differs from <code>get_capabilities</code> because
-- the later takes exclusions defined by the user into consideration.
-- </p>
-- 
-- @return list of all capabilities of this adapter
-- 
function VsAdapter:_define_capabilities()
    error("Method 'VsAdapter:_define_capabilites' is abstract.")
end 

---
-- Create a new instance of a Virtual Schema base adapter
--
-- @param object pre-initialized object
--
-- @return adapter instance
--
function VsAdapter:new(object)
    object = object or {}
    self.__index = self
    setmetatable(object, self)
    return object
end

local function subtract_capabilities(original_capabilities, excluded_capabilities)
    local filtered_capabilities = {}
    for _, capability in ipairs(original_capabilities) do
        local is_excluded = false
        for _, excluded_capability in ipairs(excluded_capabilities) do
            if excluded_capability == capability then
                is_excluded = true
            end
        end
        if not is_excluded then
            table.insert(filtered_capabilities, capability)
        end
    end
    return filtered_capabilities
end

---
-- Get the adapter capabilities.
-- <p>
-- The basic <code>get_capabilities</code> handler in this classe will out-of-the-box fit all derived adapters with the
-- rare exception of those that decide on capabilities at runtime depending on for example the version number of the
-- remote data source.
-- </p>
--
-- @param _ Exasol metadata (not used)
--
-- @param request virtual schema request
--
-- @return list of non-excluded adapter capabilities
--
function VsAdapter:get_capabilities(_, request)
    local excluded_capabilities_property_value = (((request or {}).schemaMetadataInfo or {}).properties or {})
        .EXCLUDED_CAPABILITIES
    if excluded_capabilities_property_value == nil then
        return {type = "getCapabilities", capabilities = self._define_capabilities()}
    else
        local excluded_capabilities = text.split(excluded_capabilities_property_value)
        return {
            type = "getCapabilities",
            capabilities = subtract_capabilities(self._define_capabilities(), excluded_capabilities)
        }
    end
end

---
-- Drop the virtual schema.
-- <p>
--
--
--
-- @param _ Exasol metadata (not used)
--
-- @param request virtual schema request (not used)
--
-- @return response confirming the request (otherwise empty)
--
function VsAdapter:drop_virtual_schema(_, request)
    return {type = "dropVirtualSchema"}
end

return VsAdapter

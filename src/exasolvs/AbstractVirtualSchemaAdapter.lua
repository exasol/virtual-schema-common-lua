--- This class implements an abstract base adapter with common behavior for some of the request callback functions.
-- @type AbstractVirtualSchemaAdapter
-- <p>
-- When you derive a concrete adapter from this base class, we recommend keeping it stateless. This makes
-- parallelization easier, reduces complexity and saves you the trouble of cleaning up in the drop-virtual-schema
-- request.
-- </p>
local AbstractVirtualSchemaAdapter = {}

--- Create a new instance of a Virtual Schema base adapter
-- @param object pre-initialized object
-- @return adapter instance
function AbstractVirtualSchemaAdapter:new(object)
    object = object or {}
    self.__index = self
    setmetatable(object, self)
    return object
end

--- Get the adapter name.
-- @return adapter name
function AbstractVirtualSchemaAdapter:get_name()
    error("Method 'AbstractVirtualSchemaAdapter:get_name' is abstract.")
end

--- Get the adapter version.
-- @return version of the adapter
function AbstractVirtualSchemaAdapter:get_version()
    error("Method 'AbstractVirtualSchemaAdapter:get_version' is abstract.")
end

--- Define the list of all capabilities this adapter supports.
-- <p>
-- Override this method in derived adapter class. Note that this differs from <code>get_capabilities</code> because
-- the later takes exclusions defined by the user into consideration.
-- </p>
-- @return list of all capabilities of this adapter
function AbstractVirtualSchemaAdapter:_define_capabilities()
    error("Method 'AbstractVirtualSchemaAdapter:_define_capabilites' is abstract.")
end

--- Create the Virtual Schema.
-- <p>
-- Create the virtual schema and provide the corresponding metadata.
-- </p>
-- @param _ virtual schema request
-- @param _ user-defined properties
-- @return metadata representing the structure and datatypes of the data source from Exasol's point of view
function AbstractVirtualSchemaAdapter:create_virtual_schema(_, _)
    error("Method 'AbstractVirtualSchemaAdapter:create_virtual_schema' is abstract.")
end
--- Set new adapter properties.
-- <p>
-- Changing the properties will in most cases result in the Virtual Schema metadata to be reevaluated.
-- </p>
-- @param _ virtual schema request
-- @param _ user-defined properties
-- @return same response as if you created a new Virtual Schema
function AbstractVirtualSchemaAdapter:set_properties(_, _)
    error("Method 'AbstractVirtualSchemaAdapter:set_properties' is abstract.")
end

--- Refresh the Virtual Schema.
-- <p>
-- This method reevaluates the metadata (structure and data types) that represents the data source.
-- </p>
-- @param _ virtual schema request
-- @return same response as if you created a new Virtual Schema
function AbstractVirtualSchemaAdapter:refresh(_)
    error("Method 'AbstractVirtualSchemaAdapter:refresh' is abstract.")
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

--- Get the adapter capabilities.
-- <p>
-- The basic <code>get_capabilities</code> handler in this classe will out-of-the-box fit all derived adapters with the
-- rare exception of those that decide on capabilities at runtime depending on for example the version number of the
-- remote data source.
-- </p>
-- @param _ virtual schema request
-- @param properties user-defined properties
-- @return list of non-excluded adapter capabilities
function AbstractVirtualSchemaAdapter:get_capabilities(_, properties)
    if properties:has_excluded_capabilities() then
        return {
            type = "getCapabilities",
            capabilities = subtract_capabilities(self._define_capabilities(), properties:get_excluded_capabilities())
        }
    else
        return {type = "getCapabilities", capabilities = self._define_capabilities()}
    end
end

--- Push a query down to the data source
-- @param _ virtual schema request
-- @param _ user-defined properties
-- @return rewritten query to be executed by the ExaLoader (<code>IMPORT</code>), value providing query
-- <code>SELECT ... FROM VALUES</code>, not recommended) or local Exasol query (<code>SELECT</code>).
function AbstractVirtualSchemaAdapter:push_down(_, _)
    error("Method 'AbstractVirtualSchemaAdapter:pushdown' is abstract.")
end

--- Drop the virtual schema.
-- <p>
-- Override this method to implement clean-up if the adapter is not stateless.
-- </p>
-- @param _ virtual schema request (not used)
-- @param _ user-defined properties
-- @return response confirming the request (otherwise empty)
function AbstractVirtualSchemaAdapter:drop_virtual_schema(_, _)
    return {type = "dropVirtualSchema"}
end

return AbstractVirtualSchemaAdapter
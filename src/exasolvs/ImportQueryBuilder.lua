--- Builder for an IMPORT query that wraps push-down query
-- @classmod ImportQueryBuilder
local ImportQueryBuilder = {}
ImportQueryBuilder.__index = ImportQueryBuilder

--- Create a new instance of an `ImportQueryBuilder`.
-- @return new instance
function ImportQueryBuilder:new()
    local instance = setmetatable({}, self)
    instance:_init()
    return instance
end

function ImportQueryBuilder:_init()
    -- intentionally empty
end

--- Set the result set column data types.
-- @param column_types column types as list of data type structures
-- @return self for fluent programming
function ImportQueryBuilder:column_types(column_types)
    self._column_types = column_types
    return self
end

--- Set the connection.
-- @param connection connection over which the remote query should be run
-- @return self for fluent programming
function ImportQueryBuilder:connection(connection)
    self._connection = connection
    return self
end

--- Set the push-down statement.
-- @param statement push-down statement to be wrapped by the `IMPORT` statement.
-- @return self for fluent programming
function ImportQueryBuilder:statement(statement)
    self._statement = statement
    return self
end

--- Build the `IMPORT` query structure.
-- @return table that represents the `IMPORT` statement
function ImportQueryBuilder:build()
    return {
        type = "import",
        into = self._column_types,
        connection = self._connection,
        statement = self._statement
    }
end

return ImportQueryBuilder

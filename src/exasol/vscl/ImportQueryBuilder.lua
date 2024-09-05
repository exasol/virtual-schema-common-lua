--- Builder for an IMPORT query that wraps push-down query
---@class ImportQueryBuilder
---@field _column_types TypeDefinition[]
---@field _connection string
---@field _statement SelectExpression
local ImportQueryBuilder = {}
ImportQueryBuilder.__index = ImportQueryBuilder

--- Create a new instance of an `ImportQueryBuilder`.
---@return ImportQueryBuilder new_instance
function ImportQueryBuilder:new()
    local instance = setmetatable({}, self)
    instance:_init()
    return instance
end

function ImportQueryBuilder:_init()
    -- intentionally empty
end

--- Set the result set column data types.
---@param column_types TypeDefinition[] column types as list of data type structures
---@return ImportQueryBuilder self for fluent programming
function ImportQueryBuilder:column_types(column_types)
    self._column_types = column_types
    return self
end

--- Set the connection.
---@param connection string connection over which the remote query should be run
---@return ImportQueryBuilder self for fluent programming
function ImportQueryBuilder:connection(connection)
    self._connection = connection
    return self
end

--- Set the push-down statement.
---@param statement SelectExpression push-down statement to be wrapped by the `IMPORT` statement.
---@return ImportQueryBuilder self for fluent programming
function ImportQueryBuilder:statement(statement)
    self._statement = statement
    return self
end

--- Build the `IMPORT` query structure.
---@return ImportStatement import_statement that represents the `IMPORT` statement
function ImportQueryBuilder:build()
    return {type = "import", into = self._column_types, connection = self._connection, statement = self._statement}
end

return ImportQueryBuilder

---@class ImportStatement
---@field type "import"
---@field into TypeDefinition[]
---@field connection string
---@field statement SelectExpression

local ExaError = require("ExaError")

--- This class implements a builder for `IMPORT` SQL statements.
-- @classmod exasolvs.ImportBuilder
local ImportBuilder = {
    EXA = "EXA",
    JDBC = "JDBC"
}
ImportBuilder.__index = ImportBuilder

local function _raise_illegal_type_error(type)
        ExaError:new("E-VSCL-9", "Got unknown import type {{type}} trying to create IMPORT statement.",
                {type = {value = type,
                         description = "Type of import (e.g. via JDBC connection or special EXA connection)"}}
        ):add_mitigations("Choose one of 'JDBC' or 'EXA'"):raise(2)
end

--- Create a new `ImportFromExaBuilder` that allows wrapping SQL queries in an `IMPORT ... FROM EXA` statement.
-- The default type (if no type is explicitly stated) is an import from a JDBC connection, because that is what most
-- Virtual Schemas will need.
-- @param type type of import
-- @return new builder instance
function ImportBuilder:new(type)
    if (type == nil) then
        type = ImportBuilder.JDBC
    elseif (type ~= ImportBuilder.JDBC) and (type ~= ImportBuilder.EXA) then
        _raise_illegal_type_error(type)
    end
    local instance = setmetatable({}, self)
    instance:_init(type)
    return instance
end

function ImportBuilder:_init(type)
    self._type = type
end

--- Set the SQL statement that should be run in the import.
-- @param statement statement to be run as source of the import
-- @return `self` for fluent programming
function ImportBuilder:statement(statement)
    self._statement = statement
    return self
end

--- Set the name of the connection object used in the `IMPORT` statement.
-- @param connection name of the connection to be used in the import
-- @return `self` for fluent programming
function ImportBuilder:connection(connection)
    self._connection = connection
    return self
end

--- Set the column types that the imported result set should have in Exasol.
-- When column types are explicitly specified, the ExaLoader will respect them instead of trying to determine them
-- itself.
-- @param types list of column types
-- @return `self` for fluent programming
function ImportBuilder:column_types(types)
    self._column_types = types
    return self
end

--- Get the statement with extra-quotes where necessary as it will be embedded into the IMPORT statement.
-- @return statement with escaped single quotes
local function get_statement_with_escaped_quotes(statement)
    return statement:gsub("'", "''")
end

--- Build the import statement.
-- @return `IMPORT` statement
function ImportBuilder:build()
    self:_validate()
    local parts = {"IMPORT"}
    if self._column_types then
        table.insert(parts, " INTO (")
        for i, type in ipairs(self._column_types) do
            if i > 1 then
                table.insert(parts, ", ")
            end
            table.insert(parts, "c")
            table.insert(parts, i)
            table.insert(parts, " ")
            table.insert(parts, type)
        end
        table.insert(parts, ")")
    end
    table.insert(parts, " FROM ")
    table.insert(parts, self._type)
    table.insert(parts, " AT \"")
    table.insert(parts, self._connection)
    table.insert(parts, "\" STATEMENT '")
    local escaped_statement <const> = get_statement_with_escaped_quotes(self._statement)
    table.insert(parts, escaped_statement)
    table.insert(parts, "'")
    return table.concat(parts)
end

function ImportBuilder:_validate()
    if not self._connection then
        ExaError:new("E-VSCL-10",
                "The name of the connection to the data source is missing while trying to build an IMPORT statement.")
                :add_ticket_mitigation():raise(2)
    end
    if not self._statement then
        ExaError:new("E-VSCL-11", "The SQL statement that should be executed on the data source is missing "
                        .. "trying to build an IMPORT statement.")
                :add_ticket_mitigation():raise(2)
    end
end

return ImportBuilder
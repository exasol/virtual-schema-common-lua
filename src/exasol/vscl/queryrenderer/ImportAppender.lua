--- Appender that can add top-level elements of a `SELECT` statement (or sub-select).
---@class ImportAppender: AbstractQueryAppender
local ImportAppender = {}
ImportAppender.__index = ImportAppender
local AbstractQueryAppender = require("exasol.vscl.queryrenderer.AbstractQueryAppender")
setmetatable(ImportAppender, {__index = AbstractQueryAppender})

local SelectAppender = require("exasol.vscl.queryrenderer.SelectAppender")
local Query = require("exasol.vscl.Query")

--- Create a new query renderer.
---@param out_query Query query structure as provided through the Virtual Schema API
---@return ImportAppender query_renderer instance
function ImportAppender:new(out_query)
    local instance = setmetatable({}, self)
    instance:_init(out_query)
    return instance
end

---@param out_query Query
function ImportAppender:_init(out_query)
    AbstractQueryAppender._init(self, out_query)
end

---@param connection string
function ImportAppender:_append_connection(connection)
    self:_append(' AT "')
    self:_append(connection)
    self:_append('"')
end

--- Get the statement with extra-quotes where necessary as it will be embedded into the IMPORT statement.
---@param statement SelectExpression statement for which to escape quotes
---@return string statement statement with escaped single quotes
local function get_statement_with_escaped_quotes(statement)
    local statement_out_query = Query:new()
    local select_appender = SelectAppender:new(statement_out_query)
    select_appender:append(statement)
    local rendered_statement = statement_out_query:to_string()
    local escaped_statement, _ = rendered_statement:gsub("'", "''")
    return escaped_statement
end

---@param statement SelectExpression
function ImportAppender:_append_statement(statement)
    self:_append(" STATEMENT '")
    self:_append(get_statement_with_escaped_quotes(statement))
    self:_append("'")
end

---@param into TypeDefinition[]
function ImportAppender:_append_into_clause(into)
    if (into ~= nil) and (next(into) ~= nil) then
        self:_append(" INTO (")
        for i, data_type in ipairs(into) do
            self:_comma(i)
            self:_append("c")
            self:_append(i)
            self:_append(" ")
            self:_append_data_type(data_type)
        end
        self:_append(")")
    end
end

---@param source_type string?
function ImportAppender:_append_from_clause(source_type)
    self:_append(" FROM ")
    self:_append(source_type or "EXA")
end

--- Append an `IMPORT` statement.
---@param import_query ImportStatement import query appended
function ImportAppender:append_import(import_query)
    self:_append("IMPORT")
    self:_append_into_clause(import_query.into)
    self:_append_from_clause(import_query.source_type)
    self:_append_connection(import_query.connection)
    self:_append_statement(import_query.statement)
end

-- Alias for the main entry point allows uniform appender invocation
ImportAppender.append = ImportAppender.append_import

return ImportAppender

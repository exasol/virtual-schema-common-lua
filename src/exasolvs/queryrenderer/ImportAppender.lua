--- Appender that can add top-level elements of a `SELECT` statement (or sub-select).
-- @classmod ImportAppender
local ImportAppender = {}
ImportAppender.__index = ImportAppender
local AbstractQueryRenderer = require("exasolvs.queryrenderer.AbstractQueryAppender")
setmetatable(ImportAppender, {__index = AbstractQueryRenderer})

local SelectAppender = require("exasolvs.queryrenderer.SelectAppender")
local Query = require("exasolvs.Query")

--- Create a new query renderer.
-- @param out_query query structure as provided through the Virtual Schema API
-- @return query renderer instance
function ImportAppender:new(out_query)
    local instance = setmetatable({}, self)
    instance:_init(out_query)
    return instance
end

function ImportAppender:_init(out_query)
    AbstractQueryRenderer._init(self, out_query)
end

function ImportAppender:_append_select_list_elements(select_list)
    for i = 1, #select_list do
        local element = select_list[i]
        self:_comma(i)
        self:_append_expression(element)
    end
end

function ImportAppender:_append_connection(connection)
    self:_append(' FROM EXA AT "')
    self:_append(connection)
    self:_append('"')
end

--- Get the statement with extra-quotes where necessary as it will be embedded into the IMPORT statement.
-- @param statement statement for which to escape quotes
-- @return statement with escaped single quotes
local function get_statement_with_escaped_quotes(statement)
    local statement_out_query = Query:new()
    local select_appender = SelectAppender:new(statement_out_query)
    select_appender:append(statement)
    local rendered_statement = statement_out_query:to_string()
    return rendered_statement:gsub("'", "''")
end

function ImportAppender:_append_statement(statement)
    self:_append(" STATEMENT '")
    self:_append(get_statement_with_escaped_quotes(statement))
    self:_append("'")
end

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

--- Append an `IMPORT` statement.
-- @param import_query import query appended
function ImportAppender:append_import(import_query)
    self:_append("IMPORT")
    self:_append_into_clause(import_query.into)
    self:_append_connection(import_query.connection)
    self:_append_statement(import_query.statement)
end

-- Alias for the main entry point allows uniform appender invocation
ImportAppender.append = ImportAppender.append_import

return ImportAppender
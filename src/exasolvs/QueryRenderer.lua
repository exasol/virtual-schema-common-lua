local Query = require("exasolvs.Query")
local SelectAppender = require("exasolvs.queryrenderer.SelectAppender")

--- Renderer for SQL queries.
-- @classmod QueryRenderer
local QueryRenderer = {}
QueryRenderer.__index = QueryRenderer

--- Create a new query renderer.
-- @param original_query query structure as provided through the Virtual Schema API
-- @return query renderer instance
function QueryRenderer:new(original_query)
    local instance = setmetatable({}, self)
    instance:_init(original_query)
    return instance
end

function QueryRenderer:_init(original_query)
    self.original_query = original_query
end

--- Render the query to a string.
-- @return query as string
function QueryRenderer:render()
    local out_query = Query:new()
    SelectAppender:new(out_query):append(self.original_query)
    return out_query:to_string()
end

return QueryRenderer
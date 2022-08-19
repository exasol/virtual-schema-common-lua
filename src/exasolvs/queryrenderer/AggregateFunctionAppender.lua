local ExpressionAppender = require("exasolvs.queryrenderer.ExpressionAppender")
local AbstractQueryAppender = require("exasolvs.queryrenderer.AbstractQueryAppender")
local ExaError = require("ExaError")

--- Appender for aggregate functions in an SQL statement.
-- @classmod AggregateFunctionAppender
local AggregateFunctionAppender = {}
AggregateFunctionAppender.__index = AggregateFunctionAppender
setmetatable(AggregateFunctionAppender, {__index = AbstractQueryAppender})

--- Create a new instance of a `AggregateFunctionAppender`.
-- @param out_query query to which the function will be appended
-- @return renderer for aggregate functions
function AggregateFunctionAppender:new(out_query)
    assert(out_query ~= nil, "Renderer for aggregate function requires a query object that it can append to.")
    local instance = setmetatable({}, self)
    instance:_init(out_query)
    return instance
end

function AggregateFunctionAppender:_init(out_query)
    AbstractQueryAppender._init(self, out_query)
end

--- Append an aggregate function to an SQL query.
-- @param aggregate_function function to append
function AggregateFunctionAppender:append_aggregate_function(aggregate_function)
    local function_name = string.lower(aggregate_function.name)
    local implementation = AggregateFunctionAppender["_" .. function_name]
    if implementation ~= nil then
        implementation(self, aggregate_function)
    else
        ExaError:new("E-VSCL-3", "Unable to render unsupported aggregate function type {{function_name}}.",
                {function_name =
                    {value = function_name, description = "name of the SQL function that is not yet supported"}
                }
        ):add_ticket_mitigation():raise()
    end
end

-- Alias for main appender function for uniform appender invocation
AggregateFunctionAppender.append = AggregateFunctionAppender.append_aggregate_function

function AggregateFunctionAppender:_append_expression(expression)
    local expression_renderer = ExpressionAppender:new(self._out_query)
    expression_renderer:append_expression(expression)
end

function AggregateFunctionAppender:_append_function_argument_list(arguments)
    self:_append("(")
    if (arguments) then
        for i = 1, #arguments do
            self:_comma(i)
            self:_append_expression(arguments[i])
        end
    end
    self:_append(")")
end

function AggregateFunctionAppender:_append_simple_function(f)
    self:_append(string.upper(f.name))
    self:_append_function_argument_list(f.arguments)
end

AggregateFunctionAppender._approximate_count_distinct = AggregateFunctionAppender._append_simple_function
AggregateFunctionAppender._grouping = AggregateFunctionAppender._append_simple_function
AggregateFunctionAppender._grouping_id = AggregateFunctionAppender._grouping

return AggregateFunctionAppender

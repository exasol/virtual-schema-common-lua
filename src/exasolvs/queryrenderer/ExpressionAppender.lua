local AbstractQueryAppender = require("exasolvs.queryrenderer.AbstractQueryAppender")
local text = require("text")
local ExaError = require("ExaError")

--- Appender for value expressions in a SQL query.
-- @classmod ExpressionAppender
local ExpressionAppender = {}
ExpressionAppender.__index = ExpressionAppender
setmetatable(ExpressionAppender, {__index = AbstractQueryAppender})

local OPERATORS <const> = {
    predicate_equal = "=", predicate_notequal = "<>", predicate_less = "<", predicate_greater = ">",
    predicate_lessequal = "<=", predicate_greaterequal = ">=", predicate_between = "BETWEEN",
    predicate_is_not_null = "IS NOT NULL", predicate_is_null = "IS NULL", predicate_like = "LIKE",
    predicate_like_regexp = "REGEXP_LIKE", predicate_and = "AND", predicate_or = "OR", predicate_not = "NOT"
}

local function get_predicate_operator(predicate_type)
    local operator = OPERATORS[predicate_type]
    if operator ~= nil then
        return operator
    else
        ExaError:new("E-VSCL-7", "Cannot determine operator for unknown predicate type {{type}}.",
                {type = {value = predicate_type, description = "predicate type that was not recognized"}}
        ):add_ticket_mitigation():raise()
    end
end

--- Create a new instance of an `ExpressionRenderer`.
-- @param out_query query that the rendered tokens should be appended too
-- @return expression renderer
function ExpressionAppender:new(out_query)
    assert(out_query ~= nil, "Expression renderer requires a query object that it can append to.")
    local instance = setmetatable({}, self)
    instance:_init(out_query)
    return instance
end

function ExpressionAppender:_init(out_query)
    AbstractQueryAppender._init(self, out_query)
end

function ExpressionAppender:_append_column_reference(column)
    self:_append('"')
    self:_append(column.tableName)
    self:_append('"."')
    self:_append(column.name)
    self:_append('"')
end

function ExpressionAppender:_append_exists(sub_select)
    self:_append("EXISTS(")
    require("exasolvs.queryrenderer.SelectAppender"):new(self._out_query):append_select(sub_select.query)
    self:_append(")")
end

function ExpressionAppender:_append_unary_predicate(predicate)
    self:_append("(")
    self:_append(get_predicate_operator(predicate.type))
    self:_append(" ")
    self:append_expression(predicate.expression)
    self:_append(")")
end

function ExpressionAppender:_append_binary_predicate(predicate)
    self:_append("(")
    self:append_expression(predicate.left)
    self:_append(" ")
    self:_append(get_predicate_operator(predicate.type))
    self:_append(" ")
    self:append_expression(predicate.right)
    self:_append(")")
end

function ExpressionAppender:_append_iterated_predicate(predicate)
    self:_append("(")
    local expressions = predicate.expressions
    for i = 1, #expressions do
        if i > 1 then
            self:_append(" ")
            self:_append(get_predicate_operator(predicate.type))
            self:_append(" ")
        end
        self:append_expression(expressions[i])
    end
    self:_append(")")
end

function ExpressionAppender:_append_predicate_in(predicate)
    self:_append("(")
    self:append_expression(predicate.expression)
    self:_append(" IN (")
    local arguments = predicate.arguments
    for i = 1, #arguments do
        self:_comma(i)
        self:append_expression(arguments[i])
    end
    self:_append("))")
end

function ExpressionAppender:_append_predicate_like(predicate)
    self:_append("(")
    self:append_expression(predicate.expression)
    self:_append(" LIKE ")
    self:append_expression(predicate.pattern)
    local escape = predicate.escapeChar
    if escape then
        self:_append(" ESCAPE ")
        self:append_expression(escape)
    end
    self:_append(")")
end

function ExpressionAppender:_append_predicate_regexp_like(predicate)
    self:_append("(")
    self:append_expression(predicate.expression)
    self:_append(" REGEXP_LIKE ")
    self:append_expression(predicate.pattern)
    self:_append(")")
end

function ExpressionAppender:_append_postfix_predicate(predicate)
    self:_append("(")
    self:append_expression(predicate.expression)
    self:_append(" ")
    self:_append(get_predicate_operator(predicate.type))
    self:_append(")")
end

function ExpressionAppender:_append_between(predicate)
    self:_append("(")
    self:append_expression(predicate.expression)
    self:_append(" BETWEEN ")
    self:append_expression(predicate.left)
    self:_append(" AND ")
    self:append_expression(predicate.right)
    self:_append(")")
end

--- Append a predicate to a query.
-- This method is public to allow nesting predicates in filters.
-- @param predicate predicate to append
function ExpressionAppender:append_predicate(predicate)
    local type = string.sub(predicate.type, 11)
    if type == "equal" or type == "notequal" or type == "greater" or type == "less" or type == "lessequal"
        or type == "greaterequal"
    then
        self:_append_binary_predicate(predicate)
    elseif type == "like" then
        self:_append_predicate_like(predicate)
    elseif type == "like_regexp" then
        self:_append_predicate_regexp_like(predicate)
    elseif type == "is_null" or type == "is_not_null" then
        self:_append_postfix_predicate(predicate)
    elseif type == "between" then
        self:_append_between(predicate)
    elseif type == "not" then
        self:_append_unary_predicate(predicate)
    elseif type == "and" or type == "or" then
        self:_append_iterated_predicate(predicate)
    elseif type == "in_constlist" then
        self:_append_predicate_in(predicate)
    elseif type == "exists" then
        self:_append_exists(predicate)
    else
        ExaError:new("E-VSCL-2", "Unable to render unknown SQL predicate type {{type}}.",
                {type = {value = predicate.type, description = "predicate type that was not recognized"}}
        ):add_ticket_mitigation():raise()
    end
end

function ExpressionAppender:_append_quoted_literal_expression(literal_expression)
    self:_append("'")
    self:_append(literal_expression.value)
    self:_append("'")
end

--- Append an expression to a query.
-- @param expression expression to append
function ExpressionAppender:append_expression(expression)
    local type = expression.type
    if type == "column" then
        self:_append_column_reference(expression)
    elseif type == "literal_null" then
        self:_append("null")
    elseif type == "literal_bool" then
        self:_append(expression.value and "true" or "false")
    elseif (type == "literal_exactnumeric") or (type == "literal_double") then
        self:_append(expression.value)
    elseif type == "literal_string" then
        self:_append_quoted_literal_expression(expression)
    elseif type == "literal_date" then
        self:_append("DATE ")
        self:_append_quoted_literal_expression(expression)
    elseif (type == "literal_timestamp") or (type == "literal_timestamputc") then
        self:_append("TIMESTAMP ")
        self:_append_quoted_literal_expression(expression)
    elseif type == "literal_interval" then
        self:_append("INTERVAL ")
        self:_append_quoted_literal_expression(expression)
        self:_append_interval(expression.dataType)
    elseif text.starts_with(type, "function_scalar") then
        require("exasolvs.queryrenderer.ScalarFunctionAppender"):new(self._out_query):append(expression)
    elseif text.starts_with(type, "function_aggregate") then
        require("exasolvs.queryrenderer.AggregateFunctionAppender"):new(self._out_query):append(expression)
    elseif text.starts_with(type, "predicate_") then
        self:append_predicate(expression)
    elseif type == "sub_select" then
        require("exasolvs.queryrenderer.SelectAppender"):new(self._out_query):append_sub_select(expression)
    else
        ExaError:new("E-VSCL-1", "Unable to render unknown SQL expression type {{type}}.",
            {type = {value = expression.type, description = "expression type provided"}}
        ):add_ticket_mitigation():raise(3)
    end
end

-- Alias for main appender function to allow uniform appender calls from the outside
ExpressionAppender.append = ExpressionAppender.append_expression

return ExpressionAppender
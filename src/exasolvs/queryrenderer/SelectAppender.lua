local text = require("text")
local AbstractQueryRenderer = require("exasolvs.queryrenderer.AbstractQueryAppender")
local SelectAppender = {}

--- Appender that can add top-level elements of a `SELECT` statement (or sub-select).
-- @classmod SubQueryAppender
SelectAppender.__index = SelectAppender
setmetatable(SelectAppender, {__index = AbstractQueryRenderer})

local JOIN_TYPES<const> = {inner = "INNER", left_outer = "LEFT OUTER", right_outer = "RIGHT OUTER",
                           full_outer = "FULL OUTER"}

--- Get a map of supported JOIN type to the join keyword.
-- @return join type (key) mapped to SQL join keyword
function SelectAppender.get_join_types()
    return JOIN_TYPES
end

--- Create a new query renderer.
-- @param out_query query structure as provided through the Virtual Schema API
-- @return query renderer instance
function SelectAppender:new(out_query)
    local instance = setmetatable({}, self)
    instance:_init(out_query)
    return instance
end

function SelectAppender:_init(out_query)
    AbstractQueryRenderer:_init(out_query)
end

function SelectAppender:_append_select_list_elements(select_list)
    for i = 1, #select_list do
        local element = select_list[i]
        self:_comma(i)
        self:_append_expression(element)
    end
end

function SelectAppender:_append_select_list(select_list)
    if not select_list then
        self:_append("*")
    else
        self:_append_select_list_elements(select_list)
    end
end

function SelectAppender:_append_table(table)
    self:_append('"')
    if table.schema then
        self:_append(table.schema)
        self:_append('"."')
    end
    self:_append(table.name)
    self:_append('"')
end

function SelectAppender:_append_join(join)
    local join_type_keyword = JOIN_TYPES[join.join_type]
    if join_type_keyword then
        self:_append_table(join.left)
        self:_append(' ')
        self:_append(join_type_keyword)
        self:_append(' JOIN ')
        self:_append_table(join.right)
        self:_append(' ON ')
        self:_append_expression(join.condition)
    else
        error('E-VS-QR-6: Unable to render unknown join type "' .. join.join_type .. '".')
    end
end

function SelectAppender:_append_from(from)
    if from then
        self:_append(' FROM ')
        local type = from.type
        if type == "table" then
            self:_append_table(from)
        elseif type == "join" then
            self:_append_join(from)
        else
            error('E-VS-QR-5: Unable to render unknown SQL FROM clause type "' .. type .. '".')
        end
    end
end

function SelectAppender:_append_expression(expression)
    local type = expression.type
    if text.starts_with(type, "function_scalar") then
        require("exasolvs.queryrenderer.ScalarFunctionAppender"):new(self.out_query):append_scalar_function(expression)
    else
        require("exasolvs.queryrenderer.ExpressionAppender"):new(self.out_query):append_expression(expression)
    end
end

function SelectAppender:_append_filter(filter)
    if filter then
        self:_append(" WHERE ")
        require("exasolvs.queryrenderer.ExpressionAppender"):new(self.out_query):append_predicate(filter)
    end
end

function SelectAppender:_append_limit(limit)
    if limit then
        self:_append(" LIMIT ")
        self:_append(limit.numElements)
        if limit.offset then
            self:_append(" OFFSET ")
            self:_append(limit.offset)
        end
    end
end

--- Append a sub-select statement.
-- This method is public to allow recursive queries (e.g. embedded into an `EXISTS` clause in an expression.
-- @param sub_query query appended
function SelectAppender:append_sub_select(sub_query)
    self:_append("(")
    self:append_select(sub_query)
    self:_append(")")
end

--- Append a `SELECT` statement.
-- @param sub_query query appended
function SelectAppender:append_select(sub_query)
    self:_append("SELECT ")
    self:_append_select_list(sub_query.selectList)
    self:_append_from(sub_query.from)
    self:_append_filter(sub_query.filter)
    self:_append_limit(sub_query.limit)
end

-- Alias for the main entry point allows uniform appender invocation
SelectAppender.append = SelectAppender.append_select

return SelectAppender
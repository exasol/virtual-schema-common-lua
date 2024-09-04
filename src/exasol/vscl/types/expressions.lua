local M = {}

---@class ColumnReference
---@field type "column"
---@field tableName string
---@field name string
M.ColumnReference = {}

---@class LiteralNull
---@field type "literal_null"
M.LiteralNull = {}

---@class LiteralBoolean
---@field type "literal_bool"
---@field value boolean
M.LiteralBoolean = {}

---@class LiteralExactNumeric
---@field type "literal_exactnumeric"
---@field value number
M.LiteralExactNumeric = {}

---@class LiteralDouble
---@field type "literal_double"
---@field value number
M.LiteralDouble = {}

---@class LiteralString
---@field type "literal_string"
---@field value string
M.LiteralString = {}

---@class LiteralDate
---@field type "literal_date"
---@field value string
M.LiteralDate = {}

---@class LiteralTimestamp
---@field type "literal_timestamp"
---@field value string
M.LiteralTimestamp = {}

---@class LiteralInterval
---@field type "literal_interval"
---@field value string
---@field dataType IntervalTypeDefinition
M.LiteralInterval = {}

-- Line is too long
-- luacheck: ignore
---@alias LiteralExpression LiteralNull|LiteralBoolean|LiteralExactNumeric|LiteralDouble|LiteralString|LiteralDate|LiteralTimestamp|LiteralInterval
---@alias Expression ColumnReference|LiteralExpression

---@class SubSelect
---@field type "sub_select"
---@field query SelectExpression
M.SubSelect = {}

---@class SelectExpression
---@field selectList SelectList?
---@field from string
---@field filter string
---@field groupBy string
---@field orderBy string
---@field limit string
M.SelectExpression = {}

---@class TableExpression
---@field schema string?
---@field name string
M.TableExpression = {}

---@class JoinExpression
---@field join_type "inner" | "left_outer" | "right_outer" | "full_outer"
---@field left TableExpression
---@field right TableExpression
---@field condition Expression
M.JoinExpression = {}

---@class ScalarFunctionExpression
---@field name string
M.ScalarFunctionExpression = {}

---@class AggregateFunctionExpression
---@field name string
M.AggregateFunctionExpression = {}

---@alias SelectList Expression[]

---@class BinaryPredicateExpression
---@field type  "equal"|"notequal"|"greater"|"less"|"lessequal"|"greaterequal"
---@field left Expression
---@field right Expression

---@class UnaryPredicate
---@field type "predicate_equal"|"predicate_notequal"|"predicate_less"|"predicate_greater"|"predicate_lessequal"|"predicate_greaterequal"|"predicate_between"|"predicate_is_not_null"|"predicate_is_null"|"predicate_like"|"predicate_like_regexp"|"predicate_and"|"predicate_or"|"predicate_not"|"predicate_is_json"|"predicate_is_not_json"
---@field expression Expression

---@class IteratedPredicate
---@field type "and"|"or"
---@field expressions Expression[]

---@class InPredicate
---@field type "in_constlist"
---@field expression Expression
---@field arguments Expression

---@alias PredicateExpression BinaryPredicateExpression|UnaryPredicate

return M

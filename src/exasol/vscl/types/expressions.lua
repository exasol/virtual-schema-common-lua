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

---@alias StringBasedLiteral LiteralString|LiteralDate|LiteralTimestamp|LiteralInterval
---@alias LiteralExpression LiteralNull|LiteralBoolean|LiteralExactNumeric|LiteralDouble|StringBasedLiteral
---@alias Expression ColumnReference|LiteralExpression

---@class SubSelect
---@field type "sub_select"
---@field query SelectExpression
M.SubSelect = {}

---@class SelectExpression
---@field selectList SelectList?
---@field from FromClause
---@field filter PredicateExpression?
---@field groupBy Expression[]?
---@field orderBy OrderByClause[]?
---@field limit LimitClause?
M.SelectExpression = {}

---@alias FromClause TableExpression|JoinExpression

M.FromClause = {}

---@class OrderByClause
---@field expression Expression
---@field isAscending boolean?
---@field nullsLast boolean?
M.OrderByClause = {}

---@class LimitClause
---@field numElements integer
---@field offset integer?
M.LimitClause = {}

---@class TableExpression
---@field type "table"
---@field schema string?
---@field name string
M.TableExpression = {}

---@class JoinExpression
---@field type "join"
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
-- luacheck: max line length 140
---@field type  "predicate_equal"|"predicate_notequal"|"predicate_greater"|"predicate_less"|"predicate_lessequal"|"predicate_greaterequal"
---@field left Expression
---@field right Expression
M.BinaryPredicateExpression = {}

---@class NotPredicate
---@field type "predicate_not"
---@field expression Expression
M.NotPredicate = {}

---@alias UnaryPredicate NotPredicate

---@class IteratedPredicate
---@field type "predicate_and"|"predicate_or"
---@field expressions Expression[]
M.IteratedPredicate = {}

---@class InPredicate
---@field type "predicate_in_constlist"
---@field expression Expression
---@field arguments Expression
M.InPredicate = {}

---@class ExistsPredicate
---@field type "predicate_exists"
---@field query_object SubSelect
M.ExistsPredicate = {}

---@class JsonPredicate
---@field type "predicate_is_json"|"predicate_is_not_json"
---@field expression Expression
---@field typeConstraint "VALUE"|"ARRAY"|"OBJECT"|"SCALAR"
---@field keyUniquenessConstraint "WITH UNIQUE KEYS"|"WITHOUT UNIQUE KEYS"
M.JsonPredicate = {}

---@class LikePredicate
---@field type "predicate_like"
---@field expression Expression
---@field pattern Expression
---@field escapeChar Expression?
M.LikePredicate = {}

---@class LikeRegexpPredicate
---@field type "predicate_like_regexp"
---@field expression Expression
---@field pattern Expression
M.LikeRegexpPredicate = {}

---@class PostfixPredicate
---@field type "predicate_is_null"|"predicate_is_not_null"
---@field expression Expression
M.PostfixPredicate = {}

---@class BetweenPredicate
---@field type "predicate_between"
---@field expression Expression
---@field left Expression
---@field right Expression
M.BetweenPredicate = {}

-- luacheck: max line length 180
---@alias PredicateExpression BinaryPredicateExpression|UnaryPredicate|IteratedPredicate|InPredicate|ExistsPredicate|JsonPredicate|LikePredicate|PostfixPredicate|BetweenPredicate

return M


---@class ColumnReference
---@field type "column"
---@field tableName string
---@field name string

---@class LiteralNull
---@field type "literal_null"

---@class LiteralBoolean
---@field type "literal_bool"
---@field value boolean

---@class LiteralExactNumeric
---@field type "literal_exactnumeric"
---@field value number

---@class LiteralDouble
---@field type "literal_double"
---@field value number

---@class LiteralString
---@field type "literal_string"
---@field value string

---@class LiteralDate
---@field type "literal_date"
---@field value string

---@class LiteralTimestamp
---@field type "literal_timestamp"
---@field value string

---@class LiteralInterval
---@field type "literal_interval"
---@field value string

---@alias Expression ColumnReference|LiteralNull|LiteralBoolean|LiteralExactNumeric|LiteralDouble|LiteralString|LiteralDate|LiteralTimestamp|LiteralInterval

---@class SubSelect
---@field query SelectExpression

---@class SelectExpression
---@field selectList SelectList?
---@field from string
---@field filter string
---@field groupBy string
---@field orderBy string
---@field limit string


---@alias SelectList Expression[]

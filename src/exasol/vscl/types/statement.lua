---@meta exasol_statements
local M = {}

---@class SelectSqlStatement
---@field type "select"
---@field selectList any[]?
---@field from TableExpression
---@field filter any?
---@field groupBy any[]?
---@field aggregationType ("single_group"|string)?
---@field having any?
---@field orderBy any[]?
---@field limit any?
---@field selectListDataTypes ExasolTypeDefinition[]
M.SelectSqlStatement = {}

return M

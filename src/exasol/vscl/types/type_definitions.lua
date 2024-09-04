local M = {}

---@class DecimalTypeDefinition
---@field type "DECIMAL"
---@field precision integer
---@field scale integer
M.DecimalTypeDefinition = {}

---@class CharacterTypeDefinition
---@field type "VARCHAR"
---@field size integer
---@field characterSet string?
M.CharacterTypeDefinition = {}

---@class TimestampTypeDefinition
---@field type "TIMESTAMP"
---@field withLocalTimeZone boolean
M.TimestampTypeDefinition = {}

---@class GeometryTypeDefinition
---@field type "GEOMETRY"
---@field srid integer?
M.GeometryTypeDefinition = {}

---@class IntervalTypeDefinition
---@field type "INTERVAL"
---@field fromTo string
---@field precision integer?
---@field fraction integer?
M.IntervalTypeDefinition = {}

---@class HashtypeTypeDefinition
---@field type "HASHTYPE"
---@field bytesize integer?
M.HashtypeTypeDefinition = {}

---@class DoubleTypeDefinition
---@field type "DOUBLE"
---@field bytesize integer?
M.DoubleTypeDefinition = {}

---@class DateTypeDefinition
---@field type "DATE"
---@class BooleanTypeDefinition
---@field type "BOOLEN"
M.BooleanTypeDefinition = {}

-- Line is too long
-- luacheck: ignore
---@alias TypeDefinition DecimalTypeDefinition|CharacterTypeDefinition|TimestampTypeDefinition|GeometryTypeDefinition|IntervalTypeDefinition|HashtypeTypeDefinition|DoubleTypeDefinition|DateTypeDefinition|BooleanTypeDefinition

return M

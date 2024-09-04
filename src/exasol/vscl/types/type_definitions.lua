
---@class DecimalTypeDefinition
---@field type "DECIMAL"
---@field precision integer
---@field scale integer

---@class CharacterTypeDefinition
---@field type "VARCHAR"
---@field size integer
---@field characterSet string?

---@class TimestampTypeDefinition
---@field type "TIMESTAMP"
---@field withLocalTimeZone boolean

---@class GeometryTypeDefinition
---@field type "GEOMETRY"
---@field srid integer?

---@class IntervalTypeDefinition
---@field type "INTERVAL"
---@field fromTo string
---@field precision integer?
---@field fraction integer?

---@class HashtypeTypeDefinition
---@field type "HASHTYPE"
---@field bytesize integer?

---@class DoubleTypeDefinition
---@field type "DOUBLE"
---@field bytesize integer?

---@class DateTypeDefinition
---@field type "DATE"

---@class BooleanTypeDefinition
---@field type "BOOLEN"

---@alias TypeDefinition DecimalTypeDefinition|CharacterTypeDefinition|TimestampTypeDefinition|GeometryTypeDefinition|IntervalTypeDefinition|HashtypeTypeDefinition|DoubleTypeDefinition|DateTypeDefinition|BooleanTypeDefinition

--- This class is the abstract base class of all query renderers.
--- It takes care of handling the temporary storage of the query to be constructed.
---@class AbstractQueryAppender
---@field _out_query Query
local AbstractQueryAppender = {}

local ExaError = require("ExaError")

---@param out_query Query
function AbstractQueryAppender:_init(out_query)
    self._out_query = out_query
end

--- Append a token to the query.
---@param token Token token to append
function AbstractQueryAppender:_append(token)
    self._out_query:append(token)
end

--- Append a list of tokens to the query.
---@param ... Token to append
function AbstractQueryAppender:_append_all(...)
    self._out_query:append_all(...)
end

---Append a comma in a comma-separated list where needed.
---Appends a comma if the list index is greater than one.
---@param index integer position in the comma-separated list
function AbstractQueryAppender:_comma(index)
    if index > 1 then
        self:_append(", ")
    end
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_decimal_type_details(data_type)
    self:_append("(")
    self:_append(data_type.precision)
    self:_append(",")
    self:_append(data_type.scale)
    self:_append(")")
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_character_type(data_type)
    self:_append("(")
    self:_append(data_type.size)
    self:_append(")")
    local character_set = data_type.characterSet
    if character_set then
        self:_append(" ")
        self:_append(character_set)
    end
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_timestamp(data_type)
    if data_type.withLocalTimeZone then
        self:_append(" WITH LOCAL TIME ZONE")
    end
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_geometry(data_type)
    local srid = data_type.srid
    if srid then
        self:_append("(")
        self:_append(srid)
        self:_append(")")
    end
end

---@param data_type IntervalTypeDefinition
function AbstractQueryAppender:_append_interval(data_type)
    if data_type.fromTo == "DAY TO SECONDS" then
        self:_append(" DAY")
        local precision = data_type.precision
        if precision then
            self:_append("(")
            self:_append(precision)
            self:_append(")")
        end
        self:_append(" TO SECOND")
        local fraction = data_type.fraction
        if fraction then
            self:_append("(")
            self:_append(fraction)
            self:_append(")")
        end
    else
        self:_append(" YEAR")
        local precision = data_type.precision
        if precision then
            self:_append("(")
            self:_append(precision)
            self:_append(")")
        end
        self:_append(" TO MONTH")
    end
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_hashtype(data_type)
    local byte_size = data_type.bytesize
    if byte_size then
        self:_append("(")
        self:_append(byte_size)
        self:_append(" BYTE)")
    end
end

---@param data_type TypeDefinition
function AbstractQueryAppender:_append_data_type(data_type)
    local type = data_type.type
    self:_append(type)
    if type == "DECIMAL" then
        self:_append_decimal_type_details(data_type)
    elseif type == "VARCHAR" or type == "CHAR" then
        self:_append_character_type(data_type)
    elseif type == "TIMESTAMP" then
        self:_append_timestamp(data_type)
    elseif type == "GEOMETRY" then
        self:_append_geometry(data_type)
    elseif type == "INTERVAL" then
        self:_append_interval(data_type)
    elseif type == "HASHTYPE" then
        self:_append_hashtype(data_type)
    elseif type == "DOUBLE" or type == "DATE" or type == "BOOLEAN" then
        return
    else
        ExaError:new("E-VSCL-4", "Unable to render unknown data type {{type}}.",
                     {type = {value = type, description = "data type that was not recognized"}}):add_ticket_mitigation()
                :raise()
    end
end

--- Append a string literal and enclose it in single quotes
---@param literal string string literal
function AbstractQueryAppender:_append_string_literal(literal)
    self:_append("'")
    self:_append(literal)
    self:_append("'")
end

return AbstractQueryAppender

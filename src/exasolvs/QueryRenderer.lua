local text = require("text")

local QueryRenderer = {}

local function create_existence_lookup_table(input_table)
    local lookup_table = {}
    for _, value in ipairs(input_table) do
        lookup_table[value] = true
    end
    return lookup_table
end

local SUPPORTED_SCALAR_FUNCTIONS_LIST = {
    -- Numeric functions
    "ABS", "ACOS", "ADD", "ASIN", "ATAN", "ATAN2", "CEIL", "COS", "COSH", "COT", "DEGREES", "DIV", "EXP", "FLOAT_DIV",
    "FLOOR", "LEAST", "LN", "LOG", "MOD", "MULT", "NEG", "POWER", "RADIANS", "RAND", "ROUND", "SIGN", "SIN", "SINH",
    "SQRT", "SUB", "TAN", "TANH", "TO_CHAR", "TO_NUMBER", "TRUNC",
    -- String functions
    "ASCII", "BIT_LENGTH", "CHR", "COLOGNE_PHONETIC", "CONCAT", "DUMP", "EDIT_DISTANCE", "INITCAP", "INSERT", "INSTR",
    "LENGTH", "LOCATE", "LOWER", "LPAD", "LTRIM", "OCTET_LENGTH", "REGEXP_INSTR", "REGEXP_REPLACE", "REGEXP_SUBSTR",
    "REPEAT", "REPLACE", "REVERSE", "RIGHT", "RPAD", "RTRIM", "SOUNDEX", "SPACE", "SUBSTR", "TRANSLATE", "TRIM",
    "UNICODE", "UNICODECHR", "UPPER",
    -- Date/Time functions
    "ADD_DAYS", "ADD_HOURS", "ADD_MINUTES", "ADD_MONTHS", "ADD_SECONDS", "ADD_WEEKS", "ADD_YEARS", "CONVERT_TZ",
    "CURRENT_DATE", "CURRENT_TIMESTAMP", "DATE_TRUNC", "DAY", "DAYS_BETWEEN", "DBTIMEZONE", "EXTRACT",
    "FROM_POSIX_TIME", "HOUR", "HOURS_BETWEEN", "LOCALTIMESTAMP", "MINUTE", "MINUTES_BETWEEN", "MONTH",
    "MONTHS_BETWEEN", "NUMTODSINTERVAL", "NUMTOYMINTERVAL", "POSIX_TIME", "SECOND", "SECONDS_BETWEEN",
    "SESSIONTIMEZONE", "SYSDATE", "SYSTIMESTAMP", "TO_DATE", "TO_DSINTERVAL", "TO_TIMESTAMP", "TO_YMINTERVAL", "WEEK",
    "YEAR", "YEARS_BETWEEN",
    -- Geospatial functions
    "ST_AREA", "ST_BOUNDARY", "ST_BUFFER", "ST_CENTROID", "ST_CONTAINS", "ST_CONVEXHULL", "ST_CROSSES", "ST_DIFFERENCE",
    "ST_DIMENSION", "ST_DISJOINT", "ST_DISTANCE", "ST_ENDPOINT", "ST_ENVELOPE", "ST_EQUALS", "ST_EXTERIORRING",
    "ST_FORCE2D", "ST_GEOMETRYN", "ST_GEOMETRYTYPE", "ST_INTERIORRINGN", "ST_INTERSECTION", "ST_INTERSECTS",
    "ST_ISCLOSED", "ST_ISEMPTY", "ST_ISRING", "ST_ISSIMPLE", "ST_LENGTH", "ST_NUMGEOMETRIES", "ST_NUMINTERIORRINGS",
    "ST_NUMPOINTS", "ST_OVERLAPS", "ST_POINTN", "ST_SETSRID", "ST_STARTPOINT", "ST_SYMDIFFERENCE", "ST_TOUCHES",
    "ST_TRANSFORM", "ST_UNION", "ST_WITHIN", "ST_X", "ST_Y",
    -- Bitwise functions
    "BIT_AND", "BIT_CHECK", "BIT_LROTATE", "BIT_LSHIFT", "BIT_NOT", "BIT_OR", "BIT_RROTATE", "BIT_RSHIFT", "BIT_SET",
    "BIT_TO_NUM", "BIT_XOR",
    -- Other functions
    "CURRENT_SCHEMA", "CURRENT_SESSION", "CURRENT_STATEMENT", "CURRENT_USER", "GREATEST", "HASH_MD5", "HASHTYPE_MD5",
    "HASH_SHA1", "HASHTYPE_SHA1", "HASH_SHA256", "HASHTYPE_SHA256", "HASH_SHA512", "HASHTYPE_SHA512", "HASH_TIGER",
    "HASHTYPE_TIGER", "IS_NUMBER", "IS_BOOLEAN", "IS_DATE", "IS_DSINTERVAL", "IS_YMINTERVAL", "IS_TIMESTAMP",
    "JSON_VALUE", "MIN_SCALE", "NULLIFZERO", "SYS_GUID", "TYPEOF", "ZEROIFNULL", "SESSION_PARAMETER"
}

local JOIN_TYPES = {inner = "INNER", left_outer = "LEFT OUTER", right_outer = "RIGHT OUTER", full_outer = "FULL OUTER"}

local SUPPORTED_SCALAR_FUNCTIONS = create_existence_lookup_table(SUPPORTED_SCALAR_FUNCTIONS_LIST)

local OPERATORS = {
    predicate_equal = "=", predicate_notequal = "<>", predicate_less = "<", predicate_greater = ">",
    predicate_and = "AND", predicate_or = "OR", predicate_not = "NOT"
}


---
-- Create a renderer for a given query.
--
-- @param query query to be rendered
--
-- @return renderer instance
--
function QueryRenderer.create(query)
    return QueryRenderer:new({original_query = query})
end

---
-- Get a map of supported JOIN type to the join keyword.
--
-- @return join type (key) mapped to SQL join keyword
--
function QueryRenderer.get_join_types()
    return JOIN_TYPES
end


---
-- Create a new query renderer.
--
-- @param object query to be rendered
--
-- @return query renderer instance
--
function QueryRenderer:new(object)
    object = object or {}
    self.__index = self
    setmetatable(object, self)
    self.query_elements = {}
    return object
end

-- forward declarations
--#local append_unary_predicate, append_binary_predicate, append_iterated_predicate, append_expression,
--    append_predicate_in, append_select, append_sub_select

function QueryRenderer:append(value)
    self.query_elements[#self.query_elements + 1] = value
end

function QueryRenderer:comma(index)
    if index > 1 then
        self.query_elements[#self.query_elements + 1] = ", "
    end
end

function QueryRenderer:append_column_reference(column)
    self:append('"')
    self:append(column.tableName)
    self:append('"."')
    self:append(column.name)
    self:append('"')
end

function QueryRenderer:append_function_argument_list(arguments)
    self:append("(")
    if (arguments) then
        for i = 1, #arguments do
            self:comma(i)
            self:append_expression(arguments[i])
        end
    end
    self:append(")")
end

function QueryRenderer:append_arithmetic_function(left, operator, right)
    self:append_expression(left)
    self:append(" ")
    self:append(operator)
    self:append(" ")
    self:append_expression(right)
end

local function is_parameterless_function(function_name)
    return function_name == "CURRENT_USER" or function_name == "SYSDATE" or function_name == "CURRENT_SCHEMA"
        or function_name == "CURRENT_SESSION" or function_name == "CURRENT_STATEMENT"
end

function QueryRenderer:append_scalar_function(scalar_function)
    local function_name = string.upper(scalar_function.name)
    if SUPPORTED_SCALAR_FUNCTIONS[function_name] then
        if is_parameterless_function(function_name) then
            self:append(function_name)
        else
            local arguments = scalar_function.arguments
            if function_name == "ADD" then
                self:append_arithmetic_function(arguments[1], "+", arguments[2])
            elseif function_name == "SUB" then
                self:append_arithmetic_function(arguments[1], "-", arguments[2])
            elseif function_name == "MULT" then
                self:append_arithmetic_function(arguments[1], "*", arguments[2])
            elseif function_name == "FLOAT_DIV" then
                self:append_arithmetic_function(arguments[1], "/", arguments[2])
            elseif function_name == "NEG" then
                self:append("-")
                self:append_expression(arguments[1])
            else
                self:append(function_name)
                self:append_function_argument_list(arguments)
            end
        end
    else
        error('E-VS-QR-3: Unable to render unsupported scalar function type "' .. function_name .. '".')
    end
end

function QueryRenderer:append_scalar_function_extract(scalar_function_extract)
    local to_extract = string.upper(scalar_function_extract.toExtract)
    self:append("EXTRACT(")
    self:append(to_extract)
    self:append(" FROM ")
    self:append_expression(scalar_function_extract.arguments[1])
    self:append(")")
end

function QueryRenderer:append_decimal(data_type)
    self:append("(")
    self:append(data_type.precision)
    self:append(",")
    self:append(data_type.scale)
    self:append(")")
end

function QueryRenderer:append_character_type(data_type)
    self:append("(")
    self:append(data_type.size)
    self:append(")")
    local character_set = data_type.characterSet
    if character_set then
        self:append(" ")
        self:append(character_set)
    end
end

function QueryRenderer:append_timestamp(data_type)
    if data_type.withLocalTimeZone then
        self:append(" WITH LOCAL TIME ZONE")
    end
end

function QueryRenderer:append_geometry(data_type)
    local srid = data_type.srid
    if srid then
        self:append("(")
        self:append(srid)
        self:append(")")
    end
end

function QueryRenderer:append_interval(data_type)
    if data_type.fromTo == "DAY TO SECONDS" then
        self:append(" DAY")
        local precision = data_type.precision
        if precision then
            self:append("(")
            self:append(precision)
            self:append(")")
        end
        self:append(" TO SECOND")
        local fraction = data_type.fraction
        if fraction then
            self:append("(")
            self:append(fraction)
            self:append(")")
        end
    else
        self:append(" YEAR")
        local precision = data_type.precision
        if precision then
            self:append("(")
            self:append(precision)
            self:append(")")
        end
        self:append(" TO MONTH")
    end
end

function QueryRenderer:append_hashtype(data_type)
    local byte_size = data_type.bytesize
    if byte_size then
        self:append("(")
        self:append(byte_size)
        self:append(" BYTE)")
    end
end

function QueryRenderer:append_data_type(data_type)
    local type = data_type.type
    self:append(type)
    if type == "DECIMAL" then
        self:append_decimal(data_type)
    elseif type == "VARCHAR" or type == "CHAR" then
        self:append_character_type(data_type)
    elseif type == "DOUBLE" or type == "DATE" or type == "BOOLEAN" then
        self:append("")
    elseif type == "TIMESTAMP" then
        self:append_timestamp(data_type)
    elseif type == "GEOMETRY" then
        self:append_geometry(data_type)
    elseif type == "INTERVAL" then
        self:append_interval(data_type)
    elseif type == "HASHTYPE" then
        self:append_hashtype(data_type)
    else
        error('E-VS-QR-4: Unable to render unknown data type "' .. type .. '".')
    end
end

function QueryRenderer:append_scalar_function_cast(scalar_function_cast)
    self:append("CAST(")
    self:append_expression(scalar_function_cast.arguments[1])
    self:append(" AS ")
    self:append_data_type(scalar_function_cast.dataType)
    self:append(")")
end

function QueryRenderer:append_scalar_function_json_value(scalar_function_cast_json_value)
    local arguments = scalar_function_cast_json_value.arguments
    local empty_behavior = scalar_function_cast_json_value.emptyBehavior
    local error_behavior = scalar_function_cast_json_value.errorBehavior
    self:append("JSON_VALUE(")
    self:append_expression(arguments[1])
    self:append(", ")
    self:append_expression(arguments[2])
    self:append(" RETURNING ")
    self:append_data_type(scalar_function_cast_json_value.dataType)
    self:append(" ")
    self:append(empty_behavior.type)
    if empty_behavior.type == "DEFAULT" then
        self:append(" ")
        self:append_expression(empty_behavior.expression)
    end
    self:append(" ON EMPTY ")
    self:append(error_behavior.type)
    if error_behavior.type == "DEFAULT" then
        self:append(" ")
        self:append_expression(error_behavior.expression)
    end
    self:append(" ON ERROR)")
end

function QueryRenderer:append_scalar_function_case(scalar_function_case)
    local arguments = scalar_function_case.arguments
    local results = scalar_function_case.results
    self:append("CASE ")
    self:append_expression(scalar_function_case.basis)
    for i = 1, #arguments do
        local argument = arguments[i]
        local result = results[i]
        self:append(" WHEN ")
        self:append_expression(argument)
        self:append(" THEN ")
        self:append_expression(result)
    end
    if (#results > #arguments) then
        self:append(" ELSE ")
        self:append_expression(results[#results])
    end
    self:append(" END")
end


function QueryRenderer:append_select_list_elements(select_list)
    for i = 1, #select_list do
        local element = select_list[i]
        self:comma(i)
        self:append_expression(element)
    end
end

function QueryRenderer:append_select_list(select_list)
    if not select_list then
        self:append("*")
    else
        self:append_select_list_elements(select_list)
    end
end

function QueryRenderer:append_table(table)
    self:append('"')
    if table.schema then
        self:append(table.schema)
        self:append('"."')
    end
    self:append(table.name)
    self:append('"')
end

function QueryRenderer:append_join(join)
    local join_type_keyword = JOIN_TYPES[join.join_type]
    if join_type_keyword then
        self:append_table(join.left)
        self:append(' ')
        self:append(join_type_keyword)
        self:append(' JOIN ')
        self:append_table(join.right)
        self:append(' ON ')
        self:append_expression(join.condition)
    else
        error('E-VS-QR-6: Unable to render unknown join type "' .. join.join_type .. '".')
    end
end

function QueryRenderer:append_from(from)
    if from then
        self:append(' FROM ')
        local type = from.type
        if type == "table" then
            self:append_table(from)
        elseif type == "join" then
            self:append_join(from)
        else
            error('E-VS-QR-5: Unable to render unknown SQL FROM clause type "' .. type .. '".')
        end
    end
end

function QueryRenderer:append_exists(clause)
    self:append("EXISTS(")
    self:append_select(clause.query)
    self:append(")")
end

function QueryRenderer:append_predicate(operand)
    local type = string.sub(operand.type, 11)
    if type == "equal" or type == "notequal" or type == "greater" or type == "less" then
        self:append_binary_predicate(operand)
    elseif type == "not" then
        self:append_unary_predicate(operand)
    elseif type == "and" or type == "or" then
        self:append_iterated_predicate(operand)
    elseif type == "in_constlist" then
        self:append_predicate_in(operand)
    elseif type == "exists" then
        self:append_exists(operand)
    else
        error('E-VS-QR-2: Unable to render unknown SQL predicate type "' .. type .. '".')
    end
end

function QueryRenderer:append_quoted_literal_expression(literal_expression)
    self:append("'")
    self:append(literal_expression.value)
    self:append("'")
end

function QueryRenderer:append_expression(expression)
    local type = expression.type
    if type == "column" then
        self:append_column_reference(expression)
    elseif type == "literal_null" then
        self:append("null")
    elseif type == "literal_bool" then
        self:append(expression and "true" or "false")
    elseif (type == "literal_exactnumeric") or (type == "literal_double") then
        self:append(expression.value)
    elseif type == "literal_string" then
        self:append_quoted_literal_expression(expression)
    elseif type == "literal_date" then
        self:append("DATE ")
        self:append_quoted_literal_expression(expression)
    elseif (type == "literal_timestamp") or (type == "literal_timestamputc") then
        self:append("TIMESTAMP ")
        self:append_quoted_literal_expression(expression)
    elseif type == "function_scalar" then
        self:append_scalar_function(expression)
    elseif type == "function_scalar_extract" then
        self:append_scalar_function_extract(expression)
    elseif type == "function_scalar_cast" then
        self:append_scalar_function_cast(expression)
    elseif type == "function_scalar_json_value" then
        self:append_scalar_function_json_value(expression)
    elseif type == "function_scalar_case" then
        self:append_scalar_function_case(expression)
    elseif text.starts_with(type, "predicate_") then
        self:append_predicate(expression)
    elseif type == "sub_select" then
        self:append_sub_select(expression)
    else
        error('E-VS-QR-1: Unable to render unknown SQL expression type "' .. expression.type .. '".')
    end
end

function QueryRenderer:append_unary_predicate(predicate)
    self:append("(")
    self:append(OPERATORS[predicate.type])
    self:append(" ")
    self:append_expression(predicate.expression)
    self:append(")")
end

function QueryRenderer:append_binary_predicate(predicate)
    self:append("(")
    self:append_expression(predicate.left)
    self:append(" ")
    self:append(OPERATORS[predicate.type])
    self:append(" ")
    self:append_expression(predicate.right)
    self:append(")")
end

function QueryRenderer:append_iterated_predicate(predicate)
    self:append("(")
    local expressions = predicate.expressions
    for i = 1, #expressions do
        if i > 1 then
            self:append(" ")
            self:append(OPERATORS[predicate.type])
            self:append(" ")
        end
        self:append_expression(expressions[i])
    end
    self:append(")")
end

function QueryRenderer:append_predicate_in(predicate)
    self:append("(")
    self:append_expression(predicate.expression)
    self:append(" IN (")
    local arguments = predicate.arguments
    for i = 1, #arguments do
        self:comma(i)
        self:append_expression(arguments[i])
    end
    self:append("))")
end

function QueryRenderer:append_filter(filter)
    if filter then
        self:append(" WHERE ")
        self:append_predicate(filter)
    end
end

function QueryRenderer:append_sub_select(sub_query)
    self:append("(")
    self:append_select(sub_query)
    self:append(")")
end

function QueryRenderer:append_select(sub_query)
    self:append("SELECT ")
    self:append_select_list(sub_query.selectList)
    self:append_from(sub_query.from)
    self:append_filter(sub_query.filter)
end

---
-- Render the query to a string.
--
-- @return query as string
--
function QueryRenderer:render()
    self:append_select(self.original_query)
    return table.concat(self.query_elements, "")
end

return QueryRenderer

local literal_constructors = {}

function literal_constructors.bool(value)
    return {type = "literal_bool", value = value}
end

function literal_constructors.double(value)
    return {type = "literal_double", value = value}
end

function literal_constructors.exactnumeric(value)
    return {type = "literal_exactnumeric", value = value}
end

function literal_constructors.string(value)
    return {type = "literal_string", value = value}
end

function literal_constructors.null()
    return {type = "literal_null"}
end

function literal_constructors.date(value)
    return {type = "literal_date", value = value}
end

function literal_constructors.timestamp(value)
    return {type = "literal_timestamp", value = value}
end

function literal_constructors.interval_ym(value, precision)
    return {
        type = "literal_interval",
        value = value,
        dataType = {type = "INTERVAL", fromTo = "YEAR TO MONTH", precision = precision}
    }
end

function literal_constructors.interval_ds(value, precision, fraction)
    return {
        type = "literal_interval",
        value = value,
        dataType = {type = "INTERVAL", fromTo = "DAY TO SECONDS", precision = precision, fraction = fraction}
    }
end

--- Wrap Lua literals so that they look like the literal definition the Virtual Schema API uses.
-- When fed with Lua literals, the function wraps the parameter in the corresponding VS API definition. Tables remain
-- unchanged.
-- @param ... list of Lua literals and/or tables
-- @return same list with Lua literals wrapped
function literal_constructors.wrap_literals(...)
    local wrapped_arguments = {}
    for _, argument in ipairs({...}) do
        local argument_type = type(argument)
        if argument_type == "number" then
            if math.type(argument) == "integer" then
                table.insert(wrapped_arguments, literal_constructors.exactnumeric(argument))
            elseif math.type(argument) == "float" then
                table.insert(wrapped_arguments, literal_constructors.double(argument))
            else
                error("Unrecognized number format of function argument value: " .. argument)
            end
        elseif argument_type == "string" then
            table.insert(wrapped_arguments, literal_constructors.string(argument))
        else
            table.insert(wrapped_arguments, argument)
        end
    end
    return wrapped_arguments
end

return literal_constructors

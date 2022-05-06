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

return literal_constructors
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

return literal_constructors
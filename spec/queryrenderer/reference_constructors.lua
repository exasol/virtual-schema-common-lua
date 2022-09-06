local reference_constructors = {}

function reference_constructors.column(table_id, column_id)
    return {type = "column", tableName = table_id, name = column_id}
end

return reference_constructors
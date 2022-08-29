package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local literal = require("queryrenderer.literal_constructors")
local Query = require("exasolvs.Query")
local AggregateFunctionAppender = require("exasolvs.queryrenderer.AggregateFunctionAppender")

local function it_asserts(expected, actual, explanation)
    it(explanation or expected, function() assert.are.equals(expected, actual) end)
end

local function run_complex_function(name, extra_attributes, ...)
    local out_query = Query:new()
    local renderer = AggregateFunctionAppender:new(out_query)
    local scalar_function = renderer["_" .. string.lower(name)]
    assert(scalar_function ~= nil, "Aggregate function " .. name .. " must be present in renderer")
    local wrapped_arguments = literal.wrap_literals(...)
    local attributes = {name = name, arguments = wrapped_arguments}
    for key, value in pairs(extra_attributes) do
        attributes[key] = value
    end
    scalar_function(renderer, attributes)
    return out_query:to_string()
end

--- Run a scalar function.
-- @param name name of the scalar function to run
-- @param ... arguments passed to the function
-- @return function rendered as string
local function run_function(name, ...)
    return run_complex_function(name, {}, ...)
end

describe("AggregateFunctionRenderer", function()
    it_asserts('APPROXIMATE_COUNT_DISTINCT("customers"."customer_id")',
            run_function("APPROXIMATE_COUNT_DISTINCT",
                    {type = "column", name =  "customer_id", tableName = "customers"}),
            "APPROXIMATE_COUNT_DISTINCT")

    it_asserts("COUNT(*)", run_function("COUNT"), "COUNT(*)")

    for _, grouping_alias in ipairs({"GROUPING", "GROUPING_ID"}) do
        it_asserts(grouping_alias .. '("sales"."yr", "sales"."mon")',
                run_function(grouping_alias,
                        {type = "column", name =  "yr", tableName = "sales"},
                        {type = "column", name =  "mon", tableName = "sales"}),
                grouping_alias)
    end

    for _, single_parameter_functions_without_distinct in ipairs({
        "FIRST_VALUE", "LAST_VALUE", "MEDIAN"
    }) do
        local expression = {
            type = "predicate_less",
            left = {type = "column", name = "age", tableName = "visitors"},
            right = literal.exactnumeric(30)
        }
        it_asserts(single_parameter_functions_without_distinct .. '(("visitors"."age" < 30))',
                run_function(single_parameter_functions_without_distinct, expression),
                single_parameter_functions_without_distinct)
    end


    for _, function_supporting_distinct in ipairs({
        "ANY", "COUNT", "EVERY", "MAX", "SOME", "MIN", "MUL", "STDDEV", "STDDEV_POP", "STDDEV_SAMP", "SUM", "VAR_POP",
        "VAR_SAMP", "VARIANCE"
    }) do
        local expression = {
            type = "predicate_less",
            left = {type = "column", name = "age", tableName = "visitors"},
            right = literal.exactnumeric(30)
        }
        it_asserts(function_supporting_distinct .. '(("visitors"."age" < 30))',
                run_function(function_supporting_distinct, expression),
                function_supporting_distinct)
        it_asserts(function_supporting_distinct .. '(DISTINCT ("visitors"."age" < 30))',
                run_complex_function(function_supporting_distinct, {distinct = true}, expression),
                function_supporting_distinct)
    end

    for _, double_parameter_function in ipairs({
        "CORR", "COVAR_POP", "COVAR_SAMP", "REGR_AVGX", "REGR_AVGY", "REGR_COUNT", "REGR_INTERCEPT", "REGR_R2",
        "REGR_SLOPE", "REGR_SXX", "REGR_SXY", "REGR_SYY"
    }) do
        it_asserts(double_parameter_function .. '("employees"."age", "employees"."current_salary")',
                run_function(double_parameter_function,
                            {type = "column", name = "age", tableName = "employees"},
                            {type = "column", name = "current_salary", tableName = "employees"}
                        ),
                "ANY")
    end
end)
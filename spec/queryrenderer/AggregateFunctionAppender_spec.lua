package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local literal = require("queryrenderer.literal_constructors")
local reference = require("queryrenderer.reference_constructors")
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
                run_function(grouping_alias, reference.column("sales", "yr"), reference.column("sales", "mon")),
                grouping_alias)
    end

    for _, single_parameter_functions_without_distinct in ipairs({
        "FIRST_VALUE", "LAST_VALUE", "MEDIAN"
    }) do
        local expression = {
            type = "predicate_less",
            left = reference.column("visitors", "age"),
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
                        reference.column("employees", "age"), reference.column("employees", "current_salary")),
                "ANY")
    end

    it("asserts functions that are not allowed to have a DISTINCT modifier", function()
        local renderer = AggregateFunctionAppender:new(Query:new())
        assert.has_error(function() renderer:append({name = "MEDIAN", distinct = "true"}) end,
                "Aggregate function 'MEDIAN' must not have a DISTINCT modifier.")
    end)

    it_asserts('GROUP_CONCAT("DEPARTMENTS"."NAME")',
            run_function("GROUP_CONCAT", reference.column("DEPARTMENTS", "NAME")),
            "GROUP_CONCAT with default separator")

    it_asserts([[GROUP_CONCAT(DISTINCT "PATHS"."PATH" SEPARATOR ':')]],
            run_complex_function("GROUP_CONCAT", {distinct = true, separator = ":"},
                    reference.column("PATHS", "PATH")),
            "GROUP_CONCAT with DISTINCT and a custom separator")

    it_asserts(
            [[GROUP_CONCAT("PATHS"."PATH" ORDER BY "PATHS"."PRIORITY" DESC, "PATHS"."PATH" NULLS LAST SEPARATOR ';')]],
            run_complex_function("GROUP_CONCAT",
                    {
                        separator = ";",
                        orderBy = {
                            {expression = reference.column("PATHS", "PRIORITY"), isAscending = false},
                            {expression = reference.column("PATHS", "PATH"), nullsLast = true}
                        }
                    },
                    reference.column("PATHS", "PATH")),
            "GROUP_CONCAT with DISTINCT and a custom separator")
end)
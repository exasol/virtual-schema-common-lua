package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local literal = require("queryrenderer.literal_constructors")
local Query = require("exasolvs.Query")
local AggregateFunctionAppender = require("exasolvs.queryrenderer.AggregateFunctionAppender")

function it_asserts(expected, actual, explanation)
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

    for _, grouping_alias in ipairs({"GROUPING", "GROUPING_ID"}) do
        it_asserts(grouping_alias .. '("sales"."yr", "sales"."mon")',
                run_function(grouping_alias,
                        {type = "column", name =  "yr", tableName = "sales"},
                        {type = "column", name =  "mon", tableName = "sales"}),
                grouping_alias)
    end
end)
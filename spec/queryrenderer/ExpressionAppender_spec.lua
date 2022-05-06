package.path = "src/?.lua;" .. package.path
require("busted.runner")()
require("assertions.appender_assertions")
local literal = require("queryrenderer.literal_constructors")
local ExpressionAppender = require("exasolvs.queryrenderer.ExpressionAppender")

function assert_expression_yields (expression, expected)
    assert.append_yields(ExpressionAppender, expected, expression)
end

describe("ExpressionRenderer", function()
    it("renders column reference", function()
        assert_expression_yields({type = "column", tableName = "the_table", name = "the_column"},
                '"the_table"."the_column"')
    end)

    describe("renders literal:", function()
        it("null", function()
            assert_expression_yields(literal.null() , "null")
        end)

        it("true", function()
            assert_expression_yields(literal.bool(true), "true")
        end)

        it("false", function()
            assert_expression_yields(literal.bool(false), "false")
        end)

        it("exact numeric", function()
            assert_expression_yields(literal.exactnumeric(math.pi), tostring(math.pi))
        end)

        it("double", function()
            assert_expression_yields(literal.double(1.23456789), "1.23456789")
        end)

        it("string", function()
            assert_expression_yields(literal.string("hello world"), "'hello world'")
        end)

        it("date", function()
            assert_expression_yields(literal.date("2022-12-31"), "DATE '2022-12-31'")
        end)

        it("timestamp", function()
            assert_expression_yields(literal.timestamp("12:30:24.007"), "TIMESTAMP '12:30:24.007'")
        end)
    end)

    describe("renders an embedded scalar function:", function()
        it("CURRENT_USER", function()
            assert_expression_yields({type = "function_scalar", name = "CURRENT_USER"}, "CURRENT_USER")
        end)
    end)

    describe("renders predicate:", function()
        it("unary NOT", function()
            assert_expression_yields({type = "predicate_not", expression = literal.bool(true)}, "(NOT true)")
        end)

        it("AND", function()
            assert_expression_yields({type = "predicate_and",
                                      expressions = {literal.bool(true), literal.bool(false)}}, "(true AND false)")
        end)

        it("OR", function()
            assert_expression_yields({type = "predicate_or",
                                      expressions = {literal.bool(true), literal.bool(false),
                                                         {type = "predicate_not", expression = literal.bool(true)}}},
                    "(true OR false OR (NOT true))")
        end)

        it("=", function()
            assert_expression_yields({type = "predicate_equal", left = literal.exactnumeric(4),
                                      right = literal.exactnumeric(7)}, "(4 = 7)")
        end)

        it("<>", function()
            assert_expression_yields({type = "predicate_notequal", left = literal.exactnumeric(4),
                                      right = literal.exactnumeric(7)}, "(4 <> 7)")
        end)

        it("<", function()
            assert_expression_yields({type = "predicate_less", left = literal.exactnumeric(4),
                                      right = literal.exactnumeric(7)}, "(4 < 7)")
        end)

        it(">", function()
            assert_expression_yields({type = "predicate_greater", left = literal.exactnumeric(4),
                                      right = literal.exactnumeric(7)}, "(4 > 7)")
        end)

        it("renders the predicate EXISTS in the where clause", function()
            local original_query = {
                 type = "predicate_exists",
                 query = {
                     type = "sub_select",
                     selectList = {literal.exactnumeric(1)},
                     filter = {
                         type = "predicate_greater",
                         left = {type = "column", tableName = "people", name = "age"},
                         right = literal.exactnumeric(21)
                     }
                 }
            }
            assert_expression_yields(original_query, 'EXISTS(SELECT 1 WHERE ("people"."age" > 21))')
        end)

        it("predicate IN", function()
            local original_query = {
                type = "predicate_in_constlist",
                expression = {type = "column", tableName = "open", name = "weekday"},
                arguments = {
                    literal.string("Mon"), literal.string("Tue"), literal.string("Wed"), literal.string("Thu")
                }
            }
            assert_expression_yields(original_query, [[("open"."weekday" IN ('Mon', 'Tue', 'Wed', 'Thu'))]])
        end)
    end)

    it("raises an error if the output query is missing", function()
        assert.has_error(function() ExpressionAppender:new() end,
                "Expression renderer requires a query object that it can append to.")

    end)
end)

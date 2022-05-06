package.path = "src/?.lua;" .. package.path
require("busted.runner")()
require("assertions.appender_assertions")
local SelectAppender = require("exasolvs.queryrenderer.SelectAppender")

local function assert_yields(expected, original_query)
    assert.append_yields(SelectAppender, expected, original_query)
end

local function assert_select_error(expected, original_query)
    assert.append_error(SelectAppender, expected, original_query)
end

describe("SelectAppender", function()
    it("renders SELECT *", function()
        local original_query = {
            type = "select",
            from = {type  = "table", name = "T1"}
        }
        assert_yields('SELECT * FROM "T1"', original_query)
    end)

    it("renders SELECT * from a table with given schema", function()
        local original_query = {
            type = "select",
            from = {type  = "table", schema = "S1", name = "T1"}
        }
        assert_yields('SELECT * FROM "S1"."T1"', original_query)
    end)

    it("renders a SELECT with a table and two columns", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "column", name = "C1", tableName = "T1"},
                {type = "column", name = "C2", tableName = "T1"}
            },
            from = {type  = "table", name = "T1"}
        }
        assert_yields('SELECT "T1"."C1", "T1"."C2" FROM "T1"', original_query)
    end)

    describe("renders literal", function()
        local literals = {
            {
                input = {type = "literal_null"},
                expected = "null"
            },
            {
                input = {type = "literal_string", value = "a_string"},
                expected = "'a_string'"
            },
            {
                input = {type = "literal_double", value = 3.1415},
                expected = "3.1415"},
            {
                input = {type = "literal_exactnumeric", value = 9876543210},
                expected = "9876543210"
            },
            {
                input = {type = "literal_bool", value = true},
                expected = "true"
            },
            {
                input = {type = "literal_date", value = "2015-12-01"},
                expected = "DATE '2015-12-01'"
            },
            {
                input = {type = "literal_timestamp", value = "2015-12-01 12:01:01.1234"},
                expected = "TIMESTAMP '2015-12-01 12:01:01.1234'"
            },
            {
                input = {type = "literal_timestamputc", value = "2015-12-01 12:01:01.1234"},
                expected = "TIMESTAMP '2015-12-01 12:01:01.1234'"
            }
        }
        for _, literal in ipairs(literals) do
            it("(" .. literal.input.type .. ") " .. tostring(literal.input.value), function()
                local original_query = {
                    type = "select",
                    selectList = { literal.input },
                    from = {type  = "table", name = "T1"}
                }
                assert_yields('SELECT ' .. literal.expected ..' FROM "T1"', original_query)
            end)
        end
    end)

    it("renders a single predicate filter", function()
        local original_query = {
            type = "select",
            selectList = {{type = "column", name ="NAME", tableName = "MONTHS"}},
            from = {type = "table", name = "MONTHS"},
            filter = {
                type = "predicate_greater",
                left = {type = "column", name="DAYS_IN_MONTH", tableName = "MONTHS"},
                right = {type = "literal_exactnumeric", value = "30"}
            }
        }
        assert_yields('SELECT "MONTHS"."NAME" FROM "MONTHS" WHERE ("MONTHS"."DAYS_IN_MONTH" > 30)', original_query)
    end)

    it("renders nested predicate filter", function()
        local original_query = {
            type = "select",
            selectList = {{type = "column", name ="NAME", tableName = "MONTHS"}},
            from = {type = "table", name = "MONTHS"},
            filter = {
                type = "predicate_and",
                expressions = {{
                                   type = "predicate_equal",
                                   left = {type = "literal_string", value = "Q3"},
                                   right = {type = "column", name="QUARTER", tableName = "MONTHS"}
                               }, {
                                   type = "predicate_greater",
                                   left = {type = "column", name="DAYS_IN_MONTH", tableName = "MONTHS"},
                                   right = {type = "literal_exactnumeric", value = "30"}
                               }
                }
            }
        }
        assert_yields('SELECT "MONTHS"."NAME" FROM "MONTHS" WHERE ((\'Q3\' = "MONTHS"."QUARTER") '
                .. 'AND ("MONTHS"."DAYS_IN_MONTH" > 30))', original_query)
    end)

    it("renders a unary NOT filter", function()
        local original_query = {
            type = "select",
            selectList = {{type = "column", name ="NAME", tableName = "MONTHS"}},
            from = {type = "table", name = "MONTHS"},
            filter = {
                type = "predicate_not",
                expression = {
                    type = "predicate_equal",
                    left = {type = "literal_string", value = "Q3"},
                    right = {type = "column", name="QUARTER", tableName = "MONTHS"}
                },
            }
        }
        assert_yields('SELECT "MONTHS"."NAME" FROM "MONTHS" WHERE (NOT (\'Q3\' = "MONTHS"."QUARTER"))',
                original_query)
    end)

    it("renders a scalar function in a filter in the WHERE clause", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "column", name = "LASTNAME", tableName = "PEOPLE"}
            },
            from = {type = "table", name = "PEOPLE"},
            filter = {
                type = "predicate_equal",
                left = {
                    type = "function_scalar",
                    name = "LOWER",
                    arguments = {
                        {type = "column", name = "FIRSTNAME", tableName = "PEOPLE"},
                    }
                },
                right = {type = "literal_string", value = "eve"}
            }
        }
        assert_yields([[SELECT "PEOPLE"."LASTNAME" FROM "PEOPLE" WHERE (LOWER("PEOPLE"."FIRSTNAME") = 'eve')]],
                original_query)
    end)

    it("renders the predicate IN in the where clause", function()
        local original_query = {
            type = "select",
            selectList = {{type = "literal_string", value = "hello"}},
            from = {type = "table", name = "T1"},
            filter = {
                type = "predicate_in_constlist",
                expression = {type = "column", name = "C1", tableName = "T1"},
                arguments = {
                    {type = "literal_string", value = "A1"},
                    {type = "literal_string", value = "A2"}
                }
            }
        }
        assert_yields([[SELECT 'hello' FROM "T1" WHERE ("T1"."C1" IN ('A1', 'A2'))]], original_query)
    end)

    it("renders a sub-SELECT", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "column", name = "NAME", tableName = "FRUITS"},
                {type = "column", name = "SUGAR_PERCENTAGE", tableName = "FRUITS"}
            },
            from = {type = "table", name = "FRUITS"},
            filter = {
                type = "predicate_greater",
                left = {type = "column", name = "SUGAR_PERCENTAGE", tableName = "FRUITS"},
                right = {
                    type = "sub_select",
                    selectList ={{type = "column", name = "SUGAR_PERCENTAGE", tableName = "SNACKS"}},
                    from = {type = "table", name = "SNACKS"},
                    filter = {
                        type = "predicate_equal",
                        left = {type = "column", name = "CATEGORY", tableName = "SNACKS"},
                        right = {type = "literal_string", value = "desert"}
                    }
                }
            }
        }
        assert_yields('SELECT "FRUITS"."NAME", "FRUITS"."SUGAR_PERCENTAGE" FROM "FRUITS"'
                .. ' WHERE ("FRUITS"."SUGAR_PERCENTAGE"'
                .. ' > ('
                .. 'SELECT "SNACKS"."SUGAR_PERCENTAGE" FROM "SNACKS" WHERE ("SNACKS"."CATEGORY" = \'desert\'))'
                .. ')', original_query)
    end)

    it("renders a JOIN clause", function()
        for join_type, join_keyword in pairs(SelectAppender.get_join_types()) do
            local original_query = {
                type = "select",
                selectList = {
                    {type = "column", name = "AMOUNT", tableName = "ORDERS"},
                    {type = "column", name = "NAME", tableName = "ITEMS"},
                },
                from = {
                    type = "join",
                    join_type = join_type,
                    left = {type = "table", name = "ORDERS"},
                    right = {type = "table", name = "ITEMS"},
                    condition = {
                        type = "predicate_equal",
                        left = {type = "column", name = "ITEM_ID", tableName = "ORDERS"},
                        right = {type = "column", name = "ITEM_ID", tableName = "ITEMS"}
                    }
                }
            }
            assert_yields('SELECT "ORDERS"."AMOUNT", "ITEMS"."NAME"'
                    .. ' FROM "ORDERS" ' .. join_keyword .. ' JOIN "ITEMS"'
                    .. ' ON ("ORDERS"."ITEM_ID" = "ITEMS"."ITEM_ID")', original_query)
        end
    end)

    it("raises an error if the WHERE clause type is unknown", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "literal_bool", value = false}
            },
            from = {
                type = "unknown"
            }
        }
        assert_select_error("unknown SQL FROM clause type", original_query)
    end)

    it("raises an error if the JOIN type is unknown", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "literal_bool", value = false}
            },
            from = {
                type = "join",
                join_type = "illegal"
            }
        }
        assert_select_error("unknown join type", original_query)
    end)

    it("raises and error if the predicate type is unknown", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "predicate_illegal"}
            }
        }
        assert_select_error("unknown SQL predicate type", original_query)
    end)

    it("raises an error if the expression type is unknown", function()
        local original_query = {
            type = "select",
            selectList = {
                {type = "illegal"}
            },
        }
        assert_select_error("unknown SQL expression type", original_query)
    end)

    it("raises an error if the data type is unknown", function()
        local original_query = {
            type = "select",
            selectList = {
                {
                    type = "function_scalar_cast", name = "CAST",
                    dataType = {type = "illegal"},
                    arguments = {
                        {type = "literal_string", value = "100"}
                    }
                }
            }
        }
        assert_select_error("unknown data type", original_query)
    end)
end)
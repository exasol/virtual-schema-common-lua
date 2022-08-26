package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local QueryRenderer = require("exasolvs.QueryRenderer")

describe("QueryRenderer", function()
    it("renders SELECT *", function()
        local original_query = {
            type = "select",
            from = {type  = "table", name = "T1"}
        }
        local renderer = QueryRenderer:new(original_query)
        assert.are.equals('SELECT * FROM "T1"', renderer:render())
    end)

    it("renders the aggregate function", function()
        local renderer = QueryRenderer:new({
            type = "select",
            selectList = {
                {
                    type = "function_aggregate",
                    name = "approximate_count_distinct",
                    arguments = {
                        {
                            type = "column",
                            name = "C1",
                            columnNr = 2,
                            tableName = "T2"
                        }
                    }
                }
            },
            from = {type  = "table", name = "T2"}
        })
        assert.are.equals('SELECT APPROXIMATE_COUNT_DISTINCT("T2"."C1") FROM "T2"', renderer:render())
    end)
end)
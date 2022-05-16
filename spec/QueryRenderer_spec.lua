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
end)
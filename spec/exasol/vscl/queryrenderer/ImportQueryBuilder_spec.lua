require("busted.runner")()
local ImportQueryBuilder = require("exasol.vscl.ImportQueryBuilder")

describe("ImportQueryBuilder", function()
    it("wraps a SELECT query", function()
        local wrapped_query = ImportQueryBuilder:new():connection("CA"):statement({type = "select"}):build()
        assert.are.same({type = "import", connection = "CA", statement = {type = "select"}}, wrapped_query)
    end)

    it("wraps a SELECT query with result set column types", function()
        local wrapped_query = ImportQueryBuilder:new():connection("CB"):statement({type = "select"}):column_types({
            {type = "VARCHAR"}
        }):build()
        assert.are.same(
                {type = "import", into = {{type = "VARCHAR"}}, connection = "CB", statement = {type = "select"}},
                wrapped_query)
    end)
end)

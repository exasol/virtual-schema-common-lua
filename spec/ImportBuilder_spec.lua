package.path = "src/?.lua;" .. package.path
require("busted.runner")()
local ImportBuilder = require("exasolvs.ImportBuilder")

describe("ImportBuilder", function()
    it("produces IMPORT FROM EXA", function()
        local builder = ImportBuilder:new(ImportBuilder.EXA)
        assert.are.equal("IMPORT FROM EXA AT \"the_connection\" STATEMENT 'the_statement'",
                builder:statement("the_statement"):connection("the_connection"):build()
        )
    end)

    it("adds extra quotes to single quotes in the statement", function()
        local builder = ImportBuilder:new()
        local originalSql = [[SELECT 'A text that ''already'' contains the quote symbol("''")']]
        local expectedSql = [[SELECT ''A text that ''''already'''' contains the quote symbol("''''")'']]
        assert.are.equal("IMPORT FROM JDBC AT \"another_connection\" STATEMENT '" .. expectedSql .. "'",
                builder:statement(originalSql):connection("another_connection"):build()
        )
    end)

    it("adds a column type list", function()
        local builder = ImportBuilder:new()
        assert.are.equal("IMPORT INTO (c1 VARCHAR(40), c2 BOOLEAN, c3 DATE) "
                .. "FROM JDBC AT \"yet_another_connection\" STATEMENT "
                .. "'SELECT VALID, LAST_CHECKED FROM CHECKS ORDER BY LAST_CHECKED DESC LIMIT 10'",
                builder:statement("SELECT VALID, LAST_CHECKED FROM CHECKS ORDER BY LAST_CHECKED DESC LIMIT 10")
                        :connection("yet_another_connection")
                        :column_types("VARCHAR(40)", "BOOLEAN", "DATE")
                        :build()
        )
    end)

    it("uses JDBC as default import type", function()
        assert.are.equal("JDBC", ImportBuilder:new()._type)
    end)

    it("raises an error if an unknown import type is requested", function()
        assert.has_error(function() ImportBuilder:new("illegal") end,
                [[E-VSCL-9: Got unknown import type 'illegal' trying to create IMPORT statement.

Mitigations:

* Choose one of 'JDBC' or 'EXA']]
        )
    end)

    it("raises an error if the connection is missing during build", function()
        local builder = ImportBuilder:new():statement("SELECT 1")
        assert.error_matches(function() builder:build() end,
                [[E%-VSCL%-10: The name of the connection to the data source is missing ]]
                .. "while trying to build an IMPORT statement.*"
        )
    end)

    it("raises an error if the statement is missing during build", function()
        local builder = ImportBuilder:new():connection("the_connection")
        assert.error_matches(function() builder:build() end,
                [[E%-VSCL%-11: The SQL statement that should be executed on the data source is missing ]]
                        .. "trying to build an IMPORT statement.*"
        )
    end)
end)
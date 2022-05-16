package.path = "src/?.lua;" .. package.path
require("busted.runner")()

local Query = require("exasolvs.Query")

describe("Query", function()
    it("appends token", function()
        local query = Query.create({"foo", "bar"})
        query:append("baz")
        assert.are.same({"foo", "bar", "baz"}, query.tokens)
    end)

    it("appends a series of tokens", function()
        local query = Query:new({tokens = {"before"}})
        query:append_all("foo", "bar", "baz")
        assert.are.same({"before", "foo", "bar", "baz"}, query.tokens)
    end)

    it("produces a string", function()
        local query = Query:new({tokens = {"this", " & ", "that"}})
        assert.are.equals("this & that", query:to_string())
    end)

    it("provides list of tokens", function()
        local query = Query:new({tokens = {"veni", "vidi", "vici"}})
        assert.are.same({"veni", "vidi", "vici"}, query:get_tokens())
    end)
end)
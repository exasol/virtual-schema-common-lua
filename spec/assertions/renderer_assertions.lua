local say = require("say")
local assert = require("luassert")

M = {}

local QueryRenderer = require("exasolvs.QueryRenderer")

local function renders_to(_, arguments)
    local expected = arguments[1]
    local original_query = arguments[2]
    local renderer = QueryRenderer.create(original_query)
    local ok, result = pcall(renderer.render, renderer)
    arguments[1] = original_query
    arguments[2] =expected
    if ok then
        arguments[3] = result or "<nil>"
    else
        arguments[3] = "Error: " .. result
    end
    arguments.n = 3
    return expected == result
end

local function render_error(_, arguments)
    local expected_fragment = arguments[1]
    local original_query = arguments[2]
    local renderer = QueryRenderer.create(original_query)
    local ok, result = pcall(renderer.render, renderer)
    arguments[1] = original_query
    arguments[2] = expected_fragment
    arguments.n = 3
    if ok then
        arguments[3] = "no error (unexpected success)"
        return false
    else
        arguments[3] = result
        return string.find(result, expected_fragment, 1, true) ~= nil
    end
end

say:set("assertion.renders_to.positive", "Rendered query\n%s\nExpected %s\n but got %s")
say:set("assertion.renders_to.negative", "Rendered query\n%s\nExpected a different query than %s\nbut got exactly that")
say:set("assertion.render_error.positive", "Rendered query\n%sExpected error containing:\n%sbut got: %s")
say:set("assertion.render_error.negative",
        "Rendered query\n%sExpected error not containing:\n%sbut got exactly that")

assert:register("assertion", "render_error", render_error,
        "assertion.render_error.positive", "assertion.render_error.negative")
assert:register("assertion", "renders_to", renders_to, "assertion.renders_to.positive", "assertion.renders_to.negative")

return M
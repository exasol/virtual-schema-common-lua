package.path = "src/main/lua/?.lua;" .. package.path
require("busted.runner")()
local AdapterProperties = require("exasolvs.AdapterProperties")

describe("adapter_properties", function()
    describe("validates property rule:", function()
            local tests = {
                {
                    properties = {EXCLUDED_CAPABILITIES = "a;b;c"},
                    expected = "Invalid character(s) in EXCLUDED_CAPABILITIES property"
                },
                {
                    properties = {LOG_LEVEL = "INVALID"},
                    expected = "Unknown log level 'INVALID' in LOG_LEVEL property"
                },
                {
                    properties = {DEBUG_ADDRESS = "host:no-a-number"},
                    expected = "Expected log address in DEBUG_ADDRESS to look like '<ip>|<host>[:<port>]'"
                    .. ", but got 'host:no-a-number' instead"
                }
            }
            for _, test in ipairs(tests) do
                it(test.expected, function()
                    local properties = AdapterProperties.create(test.properties)
                    assert.error_matches(function () properties:validate() end,  test.expected, 1, true)
                end)
            end
    end)

    describe("gets the DEBUG_ADDRESS property", function()
        local parameters = {
            {"192.168.0.1:4000", "192.168.0.1", 4000, "with IP address and port"},
            {"the_host:5000", "the_host", 5000, "with host and port"},
            {"another_host", "another_host", 3000, "with host and default port"}
        }
        for _, parameter in ipairs(parameters) do
            local input, expected_host, expected_port, variant = table.unpack(parameter)
            it(variant, function()
                local host, port = AdapterProperties.create({DEBUG_ADDRESS = input}):get_debug_address()
                assert.is.equal(expected_host, host, "host")
                assert.is.equal(expected_port, port, port)
            end)
        end
    end)

    it("gets the LOG_LEVEL property", function()
        assert.are.same("DEBUG", AdapterProperties.create({LOG_LEVEL = "DEBUG"}):get_log_level())
    end)

    it("gets the EXCLUDED_CAPABILITIES property", function()
        assert.are.same({"a", "b", "c"},
                AdapterProperties.create({EXCLUDED_CAPABILITIES = "a,b,c"}):get_excluded_capabilities())
    end)

    it("checks if a property is present", function()
        assert.is_true(AdapterProperties.create({FOO = "bar"}):is_property_set("FOO"))
    end)

    it("checks if a property is not present", function()
        assert.is_false(AdapterProperties.create({FOO = "bar"}):is_property_set("BAR"))
    end)

    it("checks if a property is empty", function()
        assert.is_true(AdapterProperties.create({foo = ""}):is_empty("foo"))
    end)

    it("checks if a property is not declared empty when nil", function()
        assert.is_false(AdapterProperties.create({foo = nil}):is_empty("foo"))
    end)

    it("checks if a property is not empty", function()
        assert.is_false(AdapterProperties.create({foo = "content"}):is_empty("foo"))
    end)

    it("says that the property has a value", function()
        assert.is_true(AdapterProperties.create({a = "b"}):has_value("a"))
    end)

    it("says that the property has a value no value when empty", function()
        assert.is_false(AdapterProperties.create({a = ""}):has_value("a"))
    end)

    it("says that the property has a value no value when nil", function()
        assert.is_false(AdapterProperties.create({a = nil}):has_value("a"))
    end)
end)
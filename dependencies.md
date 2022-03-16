<!-- @formatter:off -->
# Dependencies

`virtual-schema-common-lua` is a base library. It is intended to be used as a dependency in concrete implementations of Exasol Virtual Schemas.

To use this library at runtime you need Lua 5.4 or later.

## Runtime Dependencies

| Dependency                                             | License     |
|--------------------------------------------------------|-------------|
| [Lua 5.4](https://www.lua.org)                         | [MIT][mit]  |
| [lua-cjson](https://github.com/openresty/lua-cjson)    | [MIT][mit]  |
| [remotelog](https://github.com/exasol/remotelog-lua)   | [MIT][mit]  |

`lua-cjson` depends on the `cjson` library, both are preinstalled on Exasol.

`remotelog` depends on `luasocket` which is also preinstalled.

## Test Dependencies

| Dependency                               | License    |
|------------------------------------------|------------|
| [busted](http://olivinelabs.com/busted/) | [MIT][mit] |

[mit]: https://mit-license.org/
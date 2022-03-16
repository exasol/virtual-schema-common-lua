# virtual-schema-common-lua (VSCL)

This project contains a base library that abstracts Exasol's [Virtual Schema API](https://github.com/exasol/virtual-schema-common-java/blob/main/doc/development/api/virtual_schema_api.md) and provides a convenient starting point for implementing Lua-based Virtual Schemas.

Why would you want to implement a Virtual Schema in Lua?

Because it is blazingly fast. Exasol has a built-in Lua interpreter for scripting and there is no more direct approach to extend Exasol with your own functions.

## Information for Developers

* [Developer guide](doc/developer_guide/developer_guide.md)
* [Dependencies](dependencies.md)
* [License (MIT)](LICENSE)

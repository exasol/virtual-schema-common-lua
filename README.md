# virtual-schema-common-lua (VSCL)

This project contains a base library that abstracts Exasol's [Virtual Schema API](https://github.com/exasol/virtual-schema-common-java/blob/main/doc/development/api/virtual_schema_api.md) and provides a convenient starting point for implementing Lua-based Virtual Schemas.

Why would you want to implement a Virtual Schema in Lua?

Because it is blazingly fast. Exasol has a built-in Lua interpreter for scripting and there is no more direct approach to extend Exasol with your own functions.

## Information for Users

Users are developers including this library into their VS and using the API.

* [User Guide](doc/user_guide/user_guide.md)
* [API Documentation](https://exasol.github.io/virtual-schema-common-lua/api/)
* [Change Log](doc/changes/changelog.md)
* [MIT License](LICENSE)

## Information for Developers

Developers in this context are building or modifying this library.

* [Developer Guide](doc/developer_guide/developer_guide.md)
* [Dependencies](dependencies.md)
* [License (MIT)](LICENSE)

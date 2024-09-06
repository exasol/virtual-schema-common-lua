# virtual-schema-common-lua 4.1.0, released 2024-09-??

Code name: Support specifying source for `IMPORT` statement

## Summary

This release updates `ImportQueryBuilder` and `ImportAppender` to allow a custom source for the generated `IMPORT FROM` statement, e.g. `JDBC`, `EXA` and `ORA`, see the [documentation for details](https://docs.exasol.com/db/latest/sql/import.htm).

The release also updates `SelectAppender:_append_table()` to support catalogs in addition to schemas.

The release also formats all sources and adds type annotations using LuaLS.

## Features

* #89: Added support for specifying source for `IMPORT` statement
* #91: Added support for catalogs

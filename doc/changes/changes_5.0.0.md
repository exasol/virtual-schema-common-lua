# virtual-schema-common-lua 5.0.0, released 2024-09-10

Code name: Support specifying source for `IMPORT` statement

## Summary

This release updates `ImportQueryBuilder` and `ImportAppender` to allow a custom source for the generated `IMPORT FROM` statement, e.g. `JDBC`, `EXA` and `ORA`, see the [documentation for details](https://docs.exasol.com/db/latest/sql/import.htm).

The release also updates `SelectAppender:_append_table()` to support catalogs in addition to schemas.

The release also allows specifying a custom quote character for identifiers instead of the default `"`. This is a breaking change, see below for details.

The release also formats all sources and adds type annotations using LuaLS.

## Breaking Change

Class `AbstractQueryAppender` now requires an `AppenderConfig` as second argument to the constructor method `:new()`. If the configuration is missing, the constructor will fail with error message `AbstractQueryAppender requires an appender configuration`. The following constructors are affected:
* `QueryRenderer:new()`
* `AggregateFunctionAppender:new()`
* `ExpressionAppender:new()`
* `ImportAppender:new()`
* `ScalarFunctionAppender:new()`
* `SelectAppender:new()`

The configuration allows customizing the identifier quote character. If the default value `"` is OK, you can use the predefined configuration `AbstractQueryAppender.DEFAULT_APPENDER_CONFIG`.

## Features

* #89: Added support for specifying source for `IMPORT` statement
* #91: Added support for catalogs
* #92: Added support for customizing identifier quote character

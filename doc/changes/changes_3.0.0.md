# virtual-schema-common-lua 2.4.0, released 2023-03-10
 
Code name: Fixed Rockspec
 
## Summary

Release 3.0.0 improves the handling of column type lists in the import builder by accepting a table reference as first parameter to `ImportBuilder.column_types` instead of wanting all types as separate parameters. This is a breaking change, therefore the update in the major number of the library.

The builder now handles `nil` and empty list in the builder function gracefully by skipping the `INTO(...)` clause of the `IMPORT` statement.

## Bugfixes

* #73: Improved `ImportBuilder.column_types`
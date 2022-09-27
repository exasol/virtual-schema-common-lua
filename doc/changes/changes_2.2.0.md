# virtual-schema-common-lua 2.2.0, released 2022-08-??
 
Code name: Aggregate functions
 
## Summary

Release 2.2.0 of `virtual-schema-common-lua` adds SQL rendering for aggregate functions.
We also removed the standard dependency check, since it only targets Java dependencies and this project is a pure Lua project.

Known limitation:

The core database does not push the `OVER` clause that make the main difference between an analytical function and a regular aggregate function to the Virtual Schema adapter. This means VS push-down supports basic aggregate functions, but no analytical functions.

Also [GROUP_CONCAT (#50)](https://github.com/exasol/virtual-schema-common-lua/issues/50) and [LISTAGG (#19)](https://github.com/exasol/virtual-schema-common-lua/issues/19) are not yet supported.

## Features

* #17: Added rendering for aggregate functions `GROUPING` and `APPROXIMATE COUNT DISTINCT`
* #18: Added rendering aggregate functions that can have an `OVER` clause. VS does not support pushing `OVER` though.
* #47: Removed dependency check CI build
* #54: Enabled all `COUNT` variants and added more predicates

# virtual-schema-common-lua 2.3.0, released 2022-09-30
 
Code name: GROUP BY
 
## Summary

Release 2.3.0 of `virtual-schema-common-lua` adds `GROUP BY` support.

Known limitation:

The core database does not push the `OVER` clause that makes the main difference between an analytical function and a regular aggregate function to the Virtual Schema adapter. This means VS push-down supports basic aggregate functions, but no analytical functions.

Also [LISTAGG (#19)](https://github.com/exasol/virtual-schema-common-lua/issues/19) is not yet supported.

## Features

* #57: Added `GROUP BY` support.
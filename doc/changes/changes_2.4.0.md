# virtual-schema-common-lua 2.4.0, released 2023-01-??
 
Code name: Boolean Properties
 
## Summary

Release 2.4.0 of `virtual-schema-common-lua` added the methods `isTrue` and `isFalse` for checking Virtual Schema properties.

We also added support for the `IS [NOT] JSON` predicate.

Known limitation:

The core database does not push the `OVER` clause that makes the main difference between an analytical function and a regular aggregate function to the Virtual Schema adapter. This means VS push-down supports basic aggregate functions, but no analytical functions.

Also, [LISTAGG (#19)](https://github.com/exasol/virtual-schema-common-lua/issues/19) is not yet supported.

## Features

* #63: Added support for boolean Virtual Schema properties
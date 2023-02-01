# virtual-schema-common-lua 2.4.0, released 2023-02-01
 
Code name: Boolean Properties, IS JSON, LISTAGG
 
## Summary

Release 2.4.0 of `virtual-schema-common-lua` added the methods `isTrue` and `isFalse` for checking Virtual Schema properties.

We also added support for the `IS [NOT] JSON` predicate and the `LISTAGG` aggregate function.

Known limitation:

The core database does not push the `OVER` clause that makes the main difference between an analytical function and a regular aggregate function to the Virtual Schema adapter. This means VS push-down supports basic aggregate functions, but no analytical functions.

## Features

* #19: Added `LISTAGG` aggregate function rendering
* #60: Added `IS [NOT] JSON` predicate rendering
* #63: Added support for boolean Virtual Schema properties

## Bugfixes

* #67: Fixed `LISTAGG` overflow clause

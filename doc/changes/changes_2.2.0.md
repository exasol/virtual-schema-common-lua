# virtual-schema-common-lua 2.2.0, released 2022-08-??
 
Code name: Aggregate functions
 
## Summary

Release 2.2.0 of `virtual-schema-common-lua` adds SQL rendering for aggregate functions.
We also removed the standard dependency check, since it only targets Java dependencies and this project is a pure Lua project.

## Features

* #17: Added rendering for aggregate functions `GROUPING` and `APPROXIMATE COUNT DISTINCT`
* #47: Removed dependency check CI build

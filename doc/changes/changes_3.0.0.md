# virtual-schema-common-lua 3.0.0, released 2023-03-22
 
Code name: Improved IMPORT
 
## Summary

Release 3.0.0 reworked the way imports are handled. Instead of having a wrapper after rendering, we now wrap the push-down statement structure in an import structure and then render it. This is both more convenient and avoids code duplication. 

We removed the `ImportBuilder` and introduced a new `ImportQueryBuilder` which is used at an earlier stage in the rewriting process.

This is a breaking change, hence the new major version. Please check the [developer guide](../developer_guide/developer_guide.md) for more information.

## Bugfixes

* #73: Improved building of `IMPORT` statements

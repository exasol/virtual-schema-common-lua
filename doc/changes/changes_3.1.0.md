# virtual-schema-common-lua 3.1.0, released 2023-04-24
 
Code name: Validators and API documentation
 
## Summary

Release 3.1.0 brings validators that originally were created for the Exasol Virtual Schema (Lua), but are in-fact useful for all Virtual Schemas.

For consistency, we moved all tests for classes in `exasolvs` from `spec/` to `spec/exasolvs`. This has no impact on the generated library.

Additionally, we now generate the API documentation with LDoc.

## Refactoring

* #77: Moved validators from EVSL to VSCL

## Documentation

* #75: CI build now generates API documentation with LDoc 
# virtual-schema-common-lua 4.0.0, released 2023-04-27
 
Code name: Namespace changed to 'exasol.vscl'
 
## Summary

Release 4.0.0 changes the namespace from `exasolvs` to `exasol.vscl` to improve clarity, avoid collisions with namespaces of other Exasol Lua projects and make checking installations in the local Luarocks cache easier. Unfortunately this is a breaking change, hence the new major version.

## Refactoring

* #77: Changed namespace from 'exasolvs' to 'exasol.vscl'. 
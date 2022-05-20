# virtual-schema-common-lua, released 2022-05-??
 
Code name: Broader SQL coverage
 
## Summary

In this release we improved the coverage of the SQL rendering and refactored the renderer to be modular.

New SQL rendering features:

* `LIMIT`
* `ORDER BY`
* Interval types
* All scalar functions (except `LISTAGG`)

We also now use uniform error reporting with the `exaerror` module.

## Features / Enhancements

#15: Render `Limit`
#16: Render `ORDER BY`
#22: Render interval types
#24: Use `exaerror`

## Bugfixes

#30: Add missing query renderer modules to rockspec


## Refactoring

* #20: Split SQL renderer

## Dependency Updates
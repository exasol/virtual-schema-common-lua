# virtual-schema-common-lua 5.1.0, released 2026-08-14

Code name: Render TIMESTAMP Precision

## Summary

This release preserves the optional fractional-second precision of `TIMESTAMP` type definitions when rendering SQL.

## Features

* #96: Render `TIMESTAMP(p)` and `TIMESTAMP(p) WITH LOCAL TIME ZONE` in `CAST` and `JSON_VALUE ... RETURNING` expressions.

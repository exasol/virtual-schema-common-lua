# virtual-schema-common-lua 4.0.1, released 2023-07-13

Code name: Fix Issue With Integer Constants in `GROUP BY`

## Summary

This release fixes an issue with queries using `DISTINCT` with integer constants. The Exasol SQL processor turns `DISTINCT <integer>` into `GROUP BY <integer>` before push-down as an optimization. The adapter must not feed this back as Exasol interprets integers in `GROUP BY` clauses as column numbers which could lead to invalid results or the following error:

```
42000:Wrong column number. Too small value 0 as select list column reference in GROUP BY (smallest possible value is 1)
```

To fix this, Exasol VS now replaces integer constants in `GROUP BY` clauses with a constant string.

Please that you can still safely use `GROUP BY <column-number>` in your original query, since Exasol internally converts this to `GROUP BY "<column-name>"`, so that the virtual schema adapter can tell both situations apart.

## Bugfixes

* #84: Fixed issue with integer constants in `GROUP BY`

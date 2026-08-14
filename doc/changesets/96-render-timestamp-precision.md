# GH-96 Render TIMESTAMP precision

## Goal

Preserve an optional fractional-second precision from a `TIMESTAMP` type definition when VSCL renders SQL. This enables adapters to render `CAST` and `JSON_VALUE ... RETURNING` expressions accurately for both plain timestamps and timestamps with local time zone.

## Scope

In scope:

* Render `TIMESTAMP(p)` when the type definition supplies a precision from `0` through `9`.
* Render `TIMESTAMP(p) WITH LOCAL TIME ZONE` when both precision and the local-time-zone modifier are supplied.
* Keep the existing output for timestamp definitions without precision: `TIMESTAMP` and `TIMESTAMP WITH LOCAL TIME ZONE`.
* Update the LuaLS timestamp type definition and add focused renderer regression tests.
* Release the bug fix and document it in the changelog.

Out of scope:

* Validate or normalize precision values received from the Virtual Schema API.
* Change timestamp literals, other SQL data types, or the public query-renderer architecture.
* Alter the existing requirement or QueryRenderer sequence diagram, whose stated behavior already covers rendering the AST to SQL.

## Design References

* [System Requirements](../system_requirements.md) &mdash; `req~render-sql-query~1`
* [Query Push-down Model](../model/diagrams/sequence/seq_push_down.plantuml) &mdash; existing `dsn -> req~render-sql-query~1` coverage
* [Developer Guide](../developer_guide/developer_guide.md) &mdash; test, static-analysis, type-checking, and diagram-build commands
* [CI Build](../../.github/workflows/ci-build.yml) &mdash; required project quality gates

## Strategy

Extend the shared timestamp branch of `AbstractQueryAppender:_append_data_type`. After the existing `TIMESTAMP` token, append the parenthesized precision only when `data_type.precision` is present; append `WITH LOCAL TIME ZONE` afterwards when requested. This preserves both grammar order and current no-precision output for every caller of `_append_data_type`, including `CAST` and `JSON_VALUE`.

No traced requirement or design change is planned: GH-96 corrects incomplete handling within the already-traced SQL-rendering requirement. The repository does not contain the expected `doc/design/quality_requirements.md`; therefore this plan derives verification from the checked-in developer guide, trace script, and CI workflow.

## Task List

- [x] Create and checkout a new Git branch `bugfix/96-render-timestamp-precision`.

### Requirements And Design

- [x] Confirm that `req~render-sql-query~1` remains semantically accurate and keep its current revision and existing `dsn -> req~render-sql-query~1` forwarding unchanged.
- [x] No requirement or QueryRenderer sequence-diagram review was necessary; implementation remained within the existing behavior.

### Implementation

- [x] Add optional `precision: integer?` to `TimestampTypeDefinition` in `src/exasol/vscl/types/type_definition.lua`.
- [x] Update `AbstractQueryAppender:_append_timestamp` to emit `(<precision>)` before the optional ` WITH LOCAL TIME ZONE` suffix, without changing output when precision is absent.

### Verification

- [x] Add `ScalarFunctionAppender_spec.lua` regression cases for `CAST` rendering plain and local-time-zone timestamp types with explicit boundary precisions (including `0` and `9`) and without precision.
- [x] Add `ScalarFunctionAppender_spec.lua` regression cases for `JSON_VALUE ... RETURNING` timestamp types with explicit precision, with and without local time zone, and without precision.
- [x] Run the focused query-renderer specs, then `tools/run_tests.sh --run=ci`, and review the coverage report for the changed appender.
- [x] Run `tools/run_luacheck.sh` and `tools/run-type-check.sh`.
- [x] Run `tools/shellcheck.sh`, `tools/build_diagrams.sh`, and `tools/build_docs.sh` as required by the CI build.
- [x] Keep the OpenFastTrace trace clean with `tools/trace_requirements.sh`.

### Update User Documentation

- [x] Verify that the user and developer guides require no behavioral documentation change; document timestamp precision only in the release notes unless that review finds an existing type-rendering reference to update.

## Version and Changelog Update

- [x] Raise the LuaRocks package version from `5.0.1-1` to `5.1.0-1` as a backward-compatible feature release.
- [x] Add `doc/changes/changes_5.1.0.md` and link it from `doc/changes/changelog.md`, noting timestamp-precision rendering for `CAST` and `JSON_VALUE`.

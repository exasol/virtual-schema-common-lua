# AbstractQueryAppender

 This class is the abstract base class of all query renderers.
 It takes care of handling the temporary storage of the query to be constructed.

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _init


```lua
(method) AbstractQueryAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

Initializes the query appender and verifies that all parameters are set.
Raises an error if any of the parameters is missing.

@*param* `out_query` — query object that the appender appends to

@*param* `appender_config` — configuration for the query renderer (e.g. containing identifier quoting)

## _out_query


```lua
Query
```

query object that the appender appends to


---

# AbstractVirtualSchemaAdapter

 This class implements an abstract base adapter with common behavior for some of the request callback functions.

 When you derive a concrete adapter from this base class, we recommend keeping it stateless. This makes
 parallelization easier, reduces complexity and saves you the trouble of cleaning up in the drop-virtual-schema
 request.

 [impl -> dsn~lua-virtual-schema-adapter-abstraction~0]


## _define_capabilities


```lua
(method) AbstractVirtualSchemaAdapter:_define_capabilities()
  -> capabilities: string[]
```

 Define the list of all capabilities this adapter supports.
 Override this method in derived adapter class. Note that this differs from `get_capabilities` because
 the later takes exclusions defined by the user into consideration.

@*return* `capabilities` — list of all capabilities supported by this adapter

## _init


```lua
(method) AbstractVirtualSchemaAdapter:_init()
```

## create_virtual_schema


```lua
(method) AbstractVirtualSchemaAdapter:create_virtual_schema(_request: any, _properties: any)
  -> response: any
```

 Create the Virtual Schema.
 Create the virtual schema and provide the corresponding metadata.

@*param* `_request` — virtual schema request

@*param* `_properties` — user-defined properties

@*return* `response` — metadata representing the structure and datatypes of the data source from Exasol's point of view

## drop_virtual_schema


```lua
(method) AbstractVirtualSchemaAdapter:drop_virtual_schema(_request: any, _properties: any)
  -> response: any
```

 Drop the virtual schema.
 Override this method to implement clean-up if the adapter is not stateless.

@*param* `_request` — virtual schema request (not used)

@*param* `_properties` — user-defined properties

@*return* `response` — response confirming the request (otherwise empty)

## get_capabilities


```lua
(method) AbstractVirtualSchemaAdapter:get_capabilities(_request: any, properties: any)
  -> capabilities: table<string, any>
```

 Get the adapter capabilities.
 The basic `get_capabilities` handler in this class will out-of-the-box fit all derived adapters with the
 rare exception of those that decide on capabilities at runtime depending on for example the version number of the
 remote data source.

@*param* `_request` — virtual schema request

@*param* `properties` — user-defined properties

@*return* `capabilities` — list of non-excluded adapter capabilities

## get_name


```lua
(method) AbstractVirtualSchemaAdapter:get_name()
  -> adapter_name: string
```

 Get the adapter name.

@*return* `adapter_name` — name of the adapter

## get_version


```lua
(method) AbstractVirtualSchemaAdapter:get_version()
  -> version: string
```

 Get the adapter version.

@*return* `version` — version of the adapter

## push_down


```lua
(method) AbstractVirtualSchemaAdapter:push_down(_request: any, _properties: any)
  -> rewritten_query: string
```

 Push a query down to the data source

@*param* `_request` — virtual schema request

@*param* `_properties` — user-defined properties

@*return* `rewritten_query` — rewritten query to be executed by the ExaLoader (`IMPORT`), value providing query

 `SELECT ... FROM VALUES`, not recommended) or local Exasol query (`SELECT`).

## refresh


```lua
(method) AbstractVirtualSchemaAdapter:refresh(_request: any, _properties: any)
  -> response: any
```

 Refresh the Virtual Schema.
 This method reevaluates the metadata (structure and data types) that represents the data source.

@*param* `_request` — virtual schema request

@*param* `_properties` — user-defined properties

@*return* `response` — same response as if you created a new Virtual Schema

## set_properties


```lua
(method) AbstractVirtualSchemaAdapter:set_properties(_request: any, _old_properties: any, _new_properties: any)
  -> response: any
```

 Set new adapter properties.
 This request provides two sets of user-defined properties. The old ones (i.e. the ones that where set before this
 request) and the properties that the user changed.
 A new property with a key that is not present in the old set of properties means the user added a new property.
 New properties with existing keys override or unset existing properties. An unset property contains the special
 value `AdapterProperties.null`.

@*param* `_request` — virtual schema request

@*param* `_old_properties` — old user-defined properties

@*param* `_new_properties` — new user-defined properties

@*return* `response` — same response as if you created a new Virtual Schema


---

# AdapterProperties

 This class abstracts access to the user-defined properties of the Virtual Schema.

## __index


```lua
AdapterProperties
```

 This class abstracts access to the user-defined properties of the Virtual Schema.

## __tostring


```lua
(method) AdapterProperties:__tostring()
  -> string_representation: string
```

 Create a string representation

## _init


```lua
(method) AdapterProperties:_init(raw_properties: any)
```

## _raw_properties


```lua
table<string, string>
```

## _validate_debug_address


```lua
(method) AdapterProperties:_validate_debug_address()
```

## _validate_excluded_capabilities


```lua
(method) AdapterProperties:_validate_excluded_capabilities()
```

## _validate_log_level


```lua
(method) AdapterProperties:_validate_log_level()
```

## class


```lua
(method) AdapterProperties:class()
  -> class: table
```

 Get the class of the object

## get


```lua
(method) AdapterProperties:get(property_name: string)
  -> property_value: string
```

 Get the value of a property.

@*param* `property_name` — name of the property to get

## get_debug_address


```lua
(method) AdapterProperties:get_debug_address()
  -> host: string?
  2. port: integer?
```

 Get the debug address (host and port)

@*return* `host,port` — or `nil` if the property has no value

## get_excluded_capabilities


```lua
(method) AdapterProperties:get_excluded_capabilities()
  -> excluded_capabilities: string[]?
```

 Get the list of names of the excluded capabilities.

## get_log_level


```lua
(method) AdapterProperties:get_log_level()
  -> log_level: string
```

 Get the log level

## has_debug_address


```lua
(method) AdapterProperties:has_debug_address()
  -> has_debug_address: boolean
```

 Check if log address is set

@*return* `has_debug_address` — `true` if the log address is set

## has_excluded_capabilities


```lua
(method) AdapterProperties:has_excluded_capabilities()
  -> has_excluded_capabilities: boolean
```

 Check if excluded capabilities are set

@*return* `has_excluded_capabilities` — `true` if the excluded capabilities are set

## has_log_level


```lua
(method) AdapterProperties:has_log_level()
  -> has_log_level: boolean
```

 Check if the log level is set

@*return* `has_log_level` — `true` if the log level is set

## has_value


```lua
(method) AdapterProperties:has_value(property_name: string)
  -> has_value: boolean
```

 Check if the property has a non-empty value.

@*param* `property_name` — name of the property to check

@*return* `has_value` — `true` if the property has a non-empty value (i.e. not `nil` or an empty string)

## is_empty


```lua
(method) AdapterProperties:is_empty(property_name: string)
  -> is_empty: boolean
```

 Check if the property value is empty.

@*param* `property_name` — name of the property to check

@*return* `is_empty` — `true` if the property's value is empty (i.e. the property is set to an empty string)

## is_false


```lua
(method) AdapterProperties:is_false(property_name: string)
  -> is_false: boolean
```

 Check if the property evaluates to `false`.

@*param* `property_name` — name of the property to check

@*return* `is_false` — `true` if the property's value is anything else than the string `true`

## is_property_set


```lua
(method) AdapterProperties:is_property_set(property_name: string)
  -> property_set: boolean
```

 Check if the property is set.

@*param* `property_name` — name of the property to check

@*return* `property_set` — `true` if the property is set (i.e. not `nil`)

## is_true


```lua
(method) AdapterProperties:is_true(property_name: string)
  -> is_true: boolean
```

 Check if the property contains the string `true` (case-sensitive).

@*param* `property_name` — name of the property to check

@*return* `is_true` — `true` if the property's value is the string `true`

## merge


```lua
(method) AdapterProperties:merge(new_properties: AdapterProperties)
  -> merge_product: AdapterProperties
```

 Merge new properties into a set of existing ones

@*param* `new_properties` — set of new properties to merge into the existing ones

 [impl -> dsn~merging-user-defined-properties~0]

## new


```lua
(method) AdapterProperties:new(raw_properties: table<string, string>)
  -> properties: AdapterProperties
```

 Create a new instance of adapter properties.

@*param* `raw_properties` — properties as key-value pairs

@*return* `properties` — new instance

## validate


```lua
(method) AdapterProperties:validate()
```

 Validate the adapter properties.

## validate_boolean


```lua
(method) AdapterProperties:validate_boolean(property_name: any)
```

 Validate a boolean property.
Allowed values are `true`, `false` or an unset variable.


---

# AggregateFunctionAppender

 Appender for aggregate functions in an SQL statement.

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## __index


```lua
AggregateFunctionAppender
```

 Appender for aggregate functions in an SQL statement.

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_comma_separated_arguments


```lua
(method) AggregateFunctionAppender:_append_comma_separated_arguments(arguments: any)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_distinct_function


```lua
(method) AggregateFunctionAppender:_append_distinct_function(f: any)
```

## _append_distinct_modifier


```lua
(method) AggregateFunctionAppender:_append_distinct_modifier(distinct: any)
```

## _append_expression


```lua
(method) AggregateFunctionAppender:_append_expression(expression: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))
```

## _append_function_argument_list


```lua
(method) AggregateFunctionAppender:_append_function_argument_list(distinct: any, arguments: any)
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_simple_function


```lua
(method) AggregateFunctionAppender:_append_simple_function(f: any)
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _approximate_count_distinct


```lua
function
```

 AggregateFunctionAppender._any is not implemented since ANY is an alias for SOME

## _avg


```lua
function
```

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _corr


```lua
function
```

## _count


```lua
(method) AggregateFunctionAppender:_count(f: any)
```

## _covar_pop


```lua
function
```

## _covar_samp


```lua
function
```

## _every


```lua
function
```

## _first_value


```lua
function
```

## _group_concat


```lua
(method) AggregateFunctionAppender:_group_concat(f: any)
```

## _grouping


```lua
function
```

## _grouping_id


```lua
function
```

## _init


```lua
(method) AggregateFunctionAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

## _last_value


```lua
function
```

## _listagg


```lua
(method) AggregateFunctionAppender:_listagg(f: any)
```

## _max


```lua
function
```

## _median


```lua
function
```

## _min


```lua
function
```

## _mul


```lua
function
```

## _out_query


```lua
Query
```

query object that the appender appends to

## _regr_avgx


```lua
function
```

## _regr_avgy


```lua
function
```

## _regr_count


```lua
function
```

## _regr_intercept


```lua
function
```

## _regr_r2


```lua
function
```

## _regr_slope


```lua
function
```

## _regr_sxx


```lua
function
```

## _regr_sxy


```lua
function
```

## _regr_syy


```lua
function
```

## _select_appender


```lua
(method) AggregateFunctionAppender:_select_appender()
  -> SelectAppender
```

## _some


```lua
function
```

## _st_intersection


```lua
function
```

## _st_union


```lua
function
```

## _stddev


```lua
function
```

## _stddev_pop


```lua
function
```

## _stddev_samp


```lua
function
```

## _sum


```lua
function
```

## _var_pop


```lua
function
```

## _var_samp


```lua
function
```

## _variance


```lua
function
```

## append


```lua
function
```

 Alias for main appender function for uniform appender invocation

## append_aggregate_function


```lua
(method) AggregateFunctionAppender:append_aggregate_function(aggregate_function: AggregateFunctionExpression)
```

 Append an aggregate function to an SQL query.

@*param* `aggregate_function` — function to append

## new


```lua
(method) AggregateFunctionAppender:new(out_query: Query, appender_config: AppenderConfig)
  -> renderer: AggregateFunctionAppender
```

 Create a new instance of a `AggregateFunctionAppender`.

@*param* `out_query` — query to which the function will be appended

@*return* `renderer` — for aggregate functions


---

# AggregateFunctionExpression

## name


```lua
string
```


---

# AppenderConfig

## identifier_quote


```lua
string?
```

quote character for identifiers, defaults to `"`


---

# BetweenPredicate

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## left


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## right


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_between"
```


---

# BinaryPredicateExpression

## left


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## right


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_equal"|"predicate_greater"|"predicate_greaterequal"|"predicate_less"|"predicate_lessequal"...(+1)
```

 luacheck: max line length 140


---

# BooleanTypeDefinition

## type


```lua
"BOOLEAN"
```


---

# CharacterTypeDefinition

## characterSet


```lua
string?
```

## size


```lua
integer
```

## type


```lua
"VARCHAR"
```


---

# ColumnReference

## name


```lua
string
```

## tableName


```lua
string
```

## type


```lua
"column"
```


---

# Connection

An Exasol connection object

## address


```lua
string?
```

The address of the connection.

## password


```lua
string?
```

The password for the connection.

## user


```lua
string?
```

The user name for the connection.


---

# CreateVirtualSchemaResponse

Response for a createVirtualSchema request

## schemaMetadata


```lua
ExasolSchemaMetadata
```

Response for a createVirtualSchema request

## type


```lua
"createVirtualSchema"
```


---

# DateTypeDefinition

## type


```lua
"DATE"
```


---

# DecimalTypeDefinition

## precision


```lua
integer
```

## scale


```lua
integer
```

## type


```lua
"DECIMAL"
```


---

# DoubleTypeDefinition

## bytesize


```lua
integer?
```

## type


```lua
"DOUBLE"
```


---

# ExasolColumnMetadata

## adapterNotes


```lua
string?
```

Notes for the table adapter

## comment


```lua
string?
```

Comment for the column

## dataType


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)
```

Data type of the column

## default


```lua
string?
```

Default value for the column

## isIdentity


```lua
boolean?
```

Whether the column is an identity column (default: false)

## isNullable


```lua
boolean?
```

Whether the column is nullable (default: true)

## name


```lua
string
```

Name of the column


---

# ExasolDataType

```lua
{
    DECIMAL: string = DECIMAL,
    DOUBLE: string = DOUBLE,
    VARCHAR: string = VARCHAR,
    CHAR: string = CHAR,
    DATE: string = DATE,
    TIMESTAMP: string = TIMESTAMP,
    BOOLEAN: string = BOOLEAN,
    GEOMETRY: string = GEOMETRY,
    INTERVAL: string = INTERVAL,
    HASHTYPE: string = HASHTYPE,
}
```


---

# ExasolDataType.BOOLEAN


---

# ExasolDataType.CHAR


---

# ExasolDataType.DATE


---

# ExasolDataType.DECIMAL


---

# ExasolDataType.DOUBLE


---

# ExasolDataType.GEOMETRY


---

# ExasolDataType.HASHTYPE


---

# ExasolDataType.INTERVAL


---

# ExasolDataType.TIMESTAMP


---

# ExasolDataType.VARCHAR


---

# ExasolIntervalType

```lua
{
    DAY_TO_SECONDS: string = DAY TO SECONDS,
    YEAR_TO_MONTH: string = YEAR TO MONTH,
}
```


---

# ExasolIntervalType.DAY_TO_SECONDS


---

# ExasolIntervalType.YEAR_TO_MONTH


---

# ExasolObjectType

```lua
{
    TABLE: string = table,
}
```


---

# ExasolObjectType.TABLE


---

# ExasolSchemaMetadata

Response for a createVirtualSchema request

## adapterNotes


```lua
string
```

Notes for the virtual schema adapter.

## tables


```lua
ExasolTableMetadata[]
```

The tables in the virtual schema.


---

# ExasolTableMetadata

## adapterNotes


```lua
string?
```

Notes for the table adapter

## columns


```lua
ExasolColumnMetadata[]
```

Columns in the table

## comment


```lua
string?
```

Comment for the table

## name


```lua
string
```

Name of the table

## type


```lua
ExasolObjectType
```

Object type, e.g. `table`


---

# ExasolTypeDefinition

 luacheck: max line length 240


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)
```


---

# ExasolUdfContext

Context for Exasol Lua UDFs.

## get_connection


```lua
function ExasolUdfContext.get_connection(connection_name: string)
  -> connection: Connection?
```

Get the connection details for the named connection.

@*param* `connection_name` — The name of the connection.

@*return* `connection` — connection details.


---

# ExistsPredicate

## query


```lua
SelectSqlStatement
```

## type


```lua
"predicate_exists"
```


---

# Expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```


---

# ExpressionAppender

 Appender for value expressions in a SQL query.

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## __index


```lua
ExpressionAppender
```

 Appender for value expressions in a SQL query.

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_between


```lua
(method) ExpressionAppender:_append_between(predicate: BetweenPredicate)
```

## _append_binary_predicate


```lua
(method) ExpressionAppender:_append_binary_predicate(predicate: BinaryPredicateExpression)
```

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_column_reference


```lua
(method) ExpressionAppender:_append_column_reference(column: ColumnReference)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_exists


```lua
(method) ExpressionAppender:_append_exists(sub_select: ExistsPredicate)
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_iterated_predicate


```lua
(method) ExpressionAppender:_append_iterated_predicate(predicate: IteratedPredicate)
```

## _append_postfix_predicate


```lua
(method) ExpressionAppender:_append_postfix_predicate(predicate: PostfixPredicate)
```

## _append_predicate_in


```lua
(method) ExpressionAppender:_append_predicate_in(predicate: InPredicate)
```

## _append_predicate_is_json


```lua
(method) ExpressionAppender:_append_predicate_is_json(predicate: JsonPredicate)
```

## _append_predicate_like


```lua
(method) ExpressionAppender:_append_predicate_like(predicate: LikePredicate)
```

## _append_predicate_regexp_like


```lua
(method) ExpressionAppender:_append_predicate_regexp_like(predicate: LikeRegexpPredicate)
```

## _append_quoted_literal_expression


```lua
(method) ExpressionAppender:_append_quoted_literal_expression(literal_expression: LiteralDate|LiteralInterval|LiteralString|LiteralTimestamp)
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _append_unary_predicate


```lua
(method) ExpressionAppender:_append_unary_predicate(predicate: NotPredicate)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _init


```lua
(method) ExpressionAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

## _out_query


```lua
Query
```

query object that the appender appends to

## append


```lua
function
```

 Alias for main appender function to allow uniform appender calls from the outside

## append_expression


```lua
(method) ExpressionAppender:append_expression(expression: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))
```

 Append an expression to a query.

@*param* `expression` — to append

## append_predicate


```lua
(method) ExpressionAppender:append_predicate(predicate: BetweenPredicate|BinaryPredicateExpression|ExistsPredicate|InPredicate|IteratedPredicate...(+4))
```

 Append a predicate to a query.
 This method is public to allow nesting predicates in filters.

@*param* `predicate` — predicate to append

## new


```lua
(method) ExpressionAppender:new(out_query: Query, appender_config: AppenderConfig)
  -> expression_renderer: ExpressionAppender
```

 Create a new instance of an `ExpressionRenderer`.

@*param* `out_query` — query that the rendered tokens should be appended too

@*return* `expression_renderer` — new expression appender


---

# FromClause


```lua
JoinExpression|TableExpression
```


---

# GeometryTypeDefinition

## srid


```lua
integer?
```

## type


```lua
"GEOMETRY"
```


---

# HashtypeTypeDefinition

## bytesize


```lua
integer?
```

## type


```lua
"HASHTYPE"
```


---

# ImportAppender

 Appender that can add top-level elements of a `SELECT` statement (or sub-select).

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## __index


```lua
ImportAppender
```

 Appender that can add top-level elements of a `SELECT` statement (or sub-select).

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_connection


```lua
(method) ImportAppender:_append_connection(connection: string)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_from_clause


```lua
(method) ImportAppender:_append_from_clause(source_type?: string)
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_into_clause


```lua
(method) ImportAppender:_append_into_clause(into: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)[])
```

## _append_statement


```lua
(method) ImportAppender:_append_statement(statement: SelectSqlStatement)
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _init


```lua
(method) ImportAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

## _out_query


```lua
Query
```

query object that the appender appends to

## append


```lua
function
```

 Alias for the main entry point allows uniform appender invocation

## append_import


```lua
(method) ImportAppender:append_import(import_query: ImportSqlStatement)
```

 Append an `IMPORT` statement.

@*param* `import_query` — import query appended

## new


```lua
(method) ImportAppender:new(out_query: Query, appender_config: AppenderConfig)
  -> query_renderer: ImportAppender
```

 Create a new query renderer.

@*param* `out_query` — query structure as provided through the Virtual Schema API

@*return* `query_renderer` — instance


---

# ImportQueryBuilder

 Builder for an IMPORT query that wraps push-down query

## __index


```lua
ImportQueryBuilder
```

 Builder for an IMPORT query that wraps push-down query

## _column_types


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)[]
```

## _connection


```lua
string
```

## _init


```lua
(method) ImportQueryBuilder:_init()
```

## _source_type


```lua
"EXA"|"JDBC"|"ORA"
```

default: "EXA"

## _statement


```lua
SelectSqlStatement
```

## build


```lua
(method) ImportQueryBuilder:build()
  -> import_statement: ImportSqlStatement
```

 Build the `IMPORT` query structure.

@*return* `import_statement` — that represents the `IMPORT` statement

## column_types


```lua
(method) ImportQueryBuilder:column_types(column_types: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)[])
  -> self: ImportQueryBuilder
```

 Set the result set column data types.

@*param* `column_types` — column types as list of data type structures

@*return* `self` — for fluent programming

## connection


```lua
(method) ImportQueryBuilder:connection(connection: string)
  -> self: ImportQueryBuilder
```

 Set the connection.

@*param* `connection` — connection over which the remote query should be run

@*return* `self` — for fluent programming

## new


```lua
(method) ImportQueryBuilder:new()
  -> new_instance: ImportQueryBuilder
```

 Create a new instance of an `ImportQueryBuilder`.

@*return* `new_instance` — new query builder

## source_type


```lua
(method) ImportQueryBuilder:source_type(source_type: "EXA"|"JDBC"|"ORA")
  -> self: ImportQueryBuilder
```

 Set the source type to one of `EXA`, `JDBC`, `ORA`. Default: `EXA`.

@*param* `source_type` — type of the source from which to import

@*return* `self` — for fluent programming

```lua
source_type:
    | "EXA"
    | "JDBC"
    | "ORA"
```

## statement


```lua
(method) ImportQueryBuilder:statement(statement: SelectSqlStatement)
  -> self: ImportQueryBuilder
```

 Set the push-down statement.

@*param* `statement` — push-down statement to be wrapped by the `IMPORT` statement.

@*return* `self` — for fluent programming


---

# ImportSqlStatement

The ImportSqlStatement is a record (behavior-less table) that contains the structure of an `IMPORT` SQL statement.

## connection


```lua
string
```

## into


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)[]
```

## source_type


```lua
"EXA"|"JDBC"|"ORA"
```

## statement


```lua
SelectSqlStatement
```

## type


```lua
"import"
```


---

# InPredicate

## arguments


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_in_constlist"
```


---

# IntervalTypeDefinition

## fraction


```lua
integer?
```

## fromTo


```lua
string
```

## precision


```lua
integer?
```

## type


```lua
"INTERVAL"
```


---

# IteratedPredicate

## expressions


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[]
```

## type


```lua
"predicate_and"|"predicate_or"
```


---

# JoinExpression

## condition


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## join_type


```lua
"full_outer"|"inner"|"left_outer"|"right_outer"
```

## left


```lua
TableExpression
```

## right


```lua
TableExpression
```

## type


```lua
"join"
```


---

# JsonPredicate

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## keyUniquenessConstraint


```lua
"WITH UNIQUE KEYS"|"WITHOUT UNIQUE KEYS"
```

## type


```lua
"predicate_is_json"|"predicate_is_not_json"
```

## typeConstraint


```lua
"ARRAY"|"OBJECT"|"SCALAR"|"VALUE"
```


---

# LikePredicate

## escapeChar


```lua
(ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))?
```

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## pattern


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_like"
```


---

# LikeRegexpPredicate

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## pattern


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_like_regexp"
```


---

# LimitClause

## numElements


```lua
integer
```

## offset


```lua
integer?
```


---

# LiteralBoolean

## type


```lua
"literal_bool"
```

## value


```lua
boolean
```


---

# LiteralDate

## type


```lua
"literal_date"
```

## value


```lua
string
```


---

# LiteralDouble

## type


```lua
"literal_double"
```

## value


```lua
number
```


---

# LiteralExactNumeric

## type


```lua
"literal_exactnumeric"
```

## value


```lua
number
```


---

# LiteralExpression


```lua
LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric|LiteralInterval...(+3)
```


---

# LiteralInterval

## dataType


```lua
IntervalTypeDefinition
```

## type


```lua
"literal_interval"
```

## value


```lua
string
```


---

# LiteralNull

## type


```lua
"literal_null"
```


---

# LiteralString

## type


```lua
"literal_string"
```

## value


```lua
string
```


---

# LiteralTimestamp

## type


```lua
"literal_timestamp"
```

## value


```lua
string
```


---

# LuaLS


---

# NotPredicate

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_not"
```


---

# OrderByClause

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## isAscending


```lua
boolean?
```

## nullsLast


```lua
boolean?
```


---

# PostfixPredicate

## expression


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)
```

## type


```lua
"predicate_is_not_null"|"predicate_is_null"
```


---

# PredicateExpression

 luacheck: max line length 180


```lua
BetweenPredicate|BinaryPredicateExpression|ExistsPredicate|InPredicate|IteratedPredicate...(+4)
```


---

# PushdownInvolvedColumn

## dataType


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)
```

 luacheck: max line length 240

## name


```lua
string
```


---

# PushdownInvolvedTable

## adapterNotes


```lua
string?
```

## columns


```lua
PushdownInvolvedColumn[]
```

## name


```lua
string
```


---

# PushdownRequest

Pushdown request

## involvedTables


```lua
PushdownInvolvedTable[]
```

## pushdownRequest


```lua
SelectSqlStatement
```

## schemaMetadataInfo


```lua
SchemaMetadataInfo
```

Schema metadata info in requests

## type


```lua
"pushdown"
```


---

# PushdownResponse

Response for a pushdown request

## sql


```lua
string
```

The SQL statement to be executed in the remote system.

## type


```lua
"pushdown"
```


---

# Query

 This class implements an abstraction for a query string including its tokens.

## __index


```lua
Query
```

 This class implements an abstraction for a query string including its tokens.

## _init


```lua
(method) Query:_init(tokens?: string|number[])
```

## _tokens


```lua
string|number[]
```

## append


```lua
(method) Query:append(token: string|number)
```

 Append a single token.
 While the same can be achieved with calling `append_all` with a single parameter, this method is faster.

@*param* `token` — token to append

## append_all


```lua
(method) Query:append_all(...string|number)
```

 Append all tokens.

@*param* `...` — tokens to append

## get_tokens


```lua
(method) Query:get_tokens()
  -> tokens: string|number[]
```

 Get the tokens this query consists of

## new


```lua
(method) Query:new(tokens?: string|number[])
  -> query_object: Query
```

 Create a new instance of a `Query`.

@*param* `tokens` — list of tokens that make up the query

## to_string


```lua
(method) Query:to_string()
  -> query: string
```

 Return the whole query as string.

@*return* `query` — query as string


---

# QueryRenderer

 Renderer for SQL queries.

## __index


```lua
QueryRenderer
```

 Renderer for SQL queries.

## _appender_config


```lua
AppenderConfig
```

## _init


```lua
(method) QueryRenderer:_init(original_query: ImportSqlStatement|SelectSqlStatement, appender_config: AppenderConfig)
```

@*param* `original_query` — query structure as provided through the Virtual Schema API

@*param* `appender_config` — configuration for the query renderer containing identifier quoting

## _original_query


```lua
ImportSqlStatement|SelectSqlStatement
```

The ImportSqlStatement is a record (behavior-less table) that contains the structure of an `IMPORT` SQL statement.

## new


```lua
(method) QueryRenderer:new(original_query: ImportSqlStatement|SelectSqlStatement, appender_config: AppenderConfig)
  -> query_renderer: QueryRenderer
```

 Create a new query renderer.

@*param* `original_query` — query structure as provided through the Virtual Schema API

@*param* `appender_config` — configuration for the query renderer containing identifier quoting

@*return* `query_renderer` — instance

## render


```lua
(method) QueryRenderer:render()
  -> rendered_query: string
```

 Render the query to a string.

@*return* `rendered_query` — query as string


---

# QueryStatement

The ImportSqlStatement is a record (behavior-less table) that contains the structure of an `IMPORT` SQL statement.


```lua
ImportSqlStatement|SelectSqlStatement
```


---

# RefreshVirtualSchemaResponse

Response for a refresh request

## schemaMetadata


```lua
ExasolSchemaMetadata
```

Response for a createVirtualSchema request

## type


```lua
"refresh"
```


---

# RequestDispatcher

 This class dispatches Virtual Schema requests to a Virtual Schema adapter.
 It is independent of the use case of the VS adapter and offers functionality that each Virtual Schema needs, like
 JSON decoding and encoding and setting up remote logging.
 To use the dispatcher, you need to inject the concrete adapter the dispatcher should send the prepared requests to.

## __index


```lua
RequestDispatcher
```

 This class dispatches Virtual Schema requests to a Virtual Schema adapter.
 It is independent of the use case of the VS adapter and offers functionality that each Virtual Schema needs, like
 JSON decoding and encoding and setting up remote logging.
 To use the dispatcher, you need to inject the concrete adapter the dispatcher should send the prepared requests to.

## _adapter


```lua
AbstractVirtualSchemaAdapter
```

 This class implements an abstract base adapter with common behavior for some of the request callback functions.

 When you derive a concrete adapter from this base class, we recommend keeping it stateless. This makes
 parallelization easier, reduces complexity and saves you the trouble of cleaning up in the drop-virtual-schema
 request.

 [impl -> dsn~lua-virtual-schema-adapter-abstraction~0]


## _extract_new_properties


```lua
(method) RequestDispatcher:_extract_new_properties(request: any)
  -> AdapterProperties
```

 The "set properties" request contains the new properties in the `properties` element directly under the root element.

## _extract_properties


```lua
(method) RequestDispatcher:_extract_properties(request: any)
  -> AdapterProperties
```

 [impl -> dsn~reading-user-defined-properties~0]

## _handle_request


```lua
(method) RequestDispatcher:_handle_request(request: any, properties: any)
```

 [impl -> dsn~dispatching-push-down-requests~0]
 [impl -> dsn~dispatching-create-virtual-schema-requests~0]
 [impl -> dsn~dispatching-drop-virtual-schema-requests~0]
 [impl -> dsn~dispatching-refresh-requests~0]
 [impl -> dsn~dispatching-get-capabilities-requests~0]
 [impl -> dsn~dispatching-set-properties-requests~0]

## _init


```lua
(method) RequestDispatcher:_init(adapter: AbstractVirtualSchemaAdapter, properties_reader: AdapterProperties)
```

@*param* `adapter` — adapter that receives the dispatched requests

@*param* `properties_reader` — properties reader

## _init_logging


```lua
(method) RequestDispatcher:_init_logging(properties: any)
```

## _properties_reader


```lua
AdapterProperties
```

 This class abstracts access to the user-defined properties of the Virtual Schema.

## adapter_call


```lua
(method) RequestDispatcher:adapter_call(request_as_json: string)
  -> response: string
```


 RLS adapter entry point.
 <p>
 This global function receives the request from the Exasol core database.
 </p>

@*param* `request_as_json` — JSON-encoded adapter request


@*return* `response` — JSON-encoded adapter response


 [impl -> dsn~translating-json-request-to-lua-tables~0]
 [impl -> dsn~translating-lua-tables-to-json-responses~0]

## new


```lua
(method) RequestDispatcher:new(adapter: AbstractVirtualSchemaAdapter, properties_reader: AdapterProperties)
  -> dispatcher_instance: RequestDispatcher
```

 Create a new `RequestDispatcher`.

@*param* `adapter` — adapter that receives the dispatched requests

@*param* `properties_reader` — properties reader


---

# ScalarFunctionAppender

 Appender for scalar functions in an SQL statement.

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## __index


```lua
ScalarFunctionAppender
```

 Appender for scalar functions in an SQL statement.

## _abs


```lua
function
```

 Numeric functions

## _acos


```lua
function
```

## _add


```lua
(method) ScalarFunctionAppender:_add(f: any)
```

## _add_days


```lua
function
```

 Date / time functions

## _add_hours


```lua
function
```

## _add_minutes


```lua
function
```

## _add_months


```lua
function
```

## _add_seconds


```lua
function
```

## _add_weeks


```lua
function
```

## _add_years


```lua
function
```

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_arithmetic_function


```lua
(method) ScalarFunctionAppender:_append_arithmetic_function(left: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4), operator: string, right: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))
```

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_expression


```lua
(method) ScalarFunctionAppender:_append_expression(expression: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))
```

## _append_function_argument_list


```lua
(method) ScalarFunctionAppender:_append_function_argument_list(arguments: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[])
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_parameterless_function


```lua
(method) ScalarFunctionAppender:_append_parameterless_function(scalar_function: any)
```

## _append_simple_function


```lua
(method) ScalarFunctionAppender:_append_simple_function(f: any)
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _ascii


```lua
function
```

 String functions

## _asin


```lua
function
```

## _atan


```lua
function
```

## _atan2


```lua
function
```

## _bit_and


```lua
function
```

 Bitwise functions

## _bit_check


```lua
function
```

## _bit_length


```lua
function
```

## _bit_lrotate


```lua
function
```

## _bit_lshift


```lua
function
```

## _bit_not


```lua
function
```

## _bit_or


```lua
function
```

## _bit_rrotate


```lua
function
```

## _bit_rshift


```lua
function
```

## _bit_set


```lua
function
```

## _bit_to_num


```lua
function
```

## _bit_xor


```lua
function
```

## _case


```lua
(method) ScalarFunctionAppender:_case(f: any)
```

 Other functions

## _cast


```lua
(method) ScalarFunctionAppender:_cast(f: any)
```

 Conversion functions

## _ceil


```lua
function
```

## _chr


```lua
function
```

## _cologne_phonetic


```lua
function
```

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _concat


```lua
function
```

## _convert_tz


```lua
function
```

## _cos


```lua
function
```

## _cosh


```lua
function
```

## _cot


```lua
function
```

## _current_date


```lua
function
```

## _current_schema


```lua
function
```

## _current_session


```lua
function
```

## _current_statement


```lua
function
```

## _current_timestamp


```lua
function
```

## _current_user


```lua
function
```

## _date_trunc


```lua
function
```

## _day


```lua
function
```

## _days_between


```lua
function
```

## _dbtimezone


```lua
function
```

## _degrees


```lua
function
```

## _div


```lua
function
```

## _dump


```lua
function
```

## _edit_distance


```lua
function
```

## _exp


```lua
function
```

## _extract


```lua
(method) ScalarFunctionAppender:_extract(f: any)
```

## _float_div


```lua
(method) ScalarFunctionAppender:_float_div(f: any)
```

## _floor


```lua
function
```

## _from_posix_time


```lua
function
```

## _greatest


```lua
function
```

## _hash_md5


```lua
function
```

## _hash_sha1


```lua
function
```

## _hash_sha256


```lua
function
```

## _hash_sha512


```lua
function
```

## _hash_tiger


```lua
function
```

## _hashtype_md5


```lua
function
```

## _hashtype_sha1


```lua
function
```

## _hashtype_sha256


```lua
function
```

## _hashtype_sha512


```lua
function
```

## _hashtype_tiger


```lua
function
```

## _hour


```lua
function
```

## _hours_between


```lua
function
```

## _init


```lua
(method) ScalarFunctionAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

@*param* `out_query` — query to which the function will be appended

## _initcap


```lua
function
```

## _insert


```lua
function
```

## _instr


```lua
function
```

## _is_boolean


```lua
function
```

## _is_date


```lua
function
```

## _is_dsinterval


```lua
function
```

## _is_number


```lua
function
```

## _is_timestamp


```lua
function
```

## _is_yminterval


```lua
function
```

## _json_value


```lua
(method) ScalarFunctionAppender:_json_value(f: any)
```

## _least


```lua
function
```

## _left


```lua
function
```

## _length


```lua
function
```

## _ln


```lua
function
```

## _localtimestamp


```lua
function
```

## _locate


```lua
function
```

## _log


```lua
function
```

## _lower


```lua
function
```

## _lpad


```lua
function
```

## _ltrim


```lua
function
```

## _min_scale


```lua
function
```

## _minute


```lua
function
```

## _minutes_between


```lua
function
```

## _mod


```lua
function
```

## _month


```lua
function
```

## _months_between


```lua
function
```

## _mult


```lua
(method) ScalarFunctionAppender:_mult(f: any)
```

## _neg


```lua
(method) ScalarFunctionAppender:_neg(f: any)
```

## _nullifzero


```lua
function
```

## _numtodsinterval


```lua
function
```

## _numtoyminterval


```lua
function
```

## _octet_length


```lua
function
```

## _out_query


```lua
Query
```

query object that the appender appends to

## _pi


```lua
function
```

## _posix_time


```lua
function
```

## _power


```lua
function
```

## _radians


```lua
function
```

## _rand


```lua
function
```

## _regexp_instr


```lua
function
```

## _regexp_substr


```lua
function
```

## _repeat


```lua
function
```

## _replace


```lua
function
```

## _reverse


```lua
function
```

## _right


```lua
function
```

## _round


```lua
function
```

## _rpad


```lua
function
```

## _rtrim


```lua
function
```

## _second


```lua
function
```

## _seconds_between


```lua
function
```

## _session_parameter


```lua
function
```

## _sessiontimezone


```lua
function
```

## _sign


```lua
function
```

## _sin


```lua
function
```

## _sinh


```lua
function
```

## _soundex


```lua
function
```

## _space


```lua
function
```

## _sqrt


```lua
function
```

## _st_area


```lua
function
```

 Polygon functions

## _st_boundary


```lua
function
```

 General geospatial functions

## _st_buffer


```lua
function
```

## _st_centroid


```lua
function
```

## _st_contains


```lua
function
```

## _st_convexhull


```lua
function
```

## _st_crosses


```lua
function
```

## _st_difference


```lua
function
```

## _st_dimension


```lua
function
```

## _st_disjoint


```lua
function
```

## _st_distance


```lua
function
```

## _st_endpoint


```lua
function
```

 Linestring functions

## _st_envelope


```lua
function
```

## _st_equals


```lua
function
```

## _st_exteriorring


```lua
function
```

## _st_force2d


```lua
function
```

## _st_geometryn


```lua
function
```

 Geometry collection functions

## _st_geometrytype


```lua
function
```

## _st_interiorringn


```lua
function
```

## _st_intersection


```lua
function
```

## _st_intersects


```lua
function
```

## _st_isclosed


```lua
function
```

## _st_isempty


```lua
function
```

## _st_isring


```lua
function
```

## _st_issimple


```lua
function
```

## _st_length


```lua
function
```

## _st_numgeometries


```lua
function
```

## _st_numinteriorrings


```lua
function
```

## _st_numpoints


```lua
function
```

## _st_overlaps


```lua
function
```

## _st_pointn


```lua
function
```

## _st_setsrid


```lua
function
```

## _st_startpoint


```lua
function
```

## _st_symdifference


```lua
function
```

## _st_touches


```lua
function
```

## _st_transform


```lua
function
```

## _st_union


```lua
function
```

## _st_within


```lua
function
```

## _st_x


```lua
function
```

 Geospatial functions
 Point functions

## _st_y


```lua
function
```

## _sub


```lua
(method) ScalarFunctionAppender:_sub(f: any)
```

## _substr


```lua
function
```

## _sys_guid


```lua
function
```

## _sysdate


```lua
function
```

## _systimestamp


```lua
function
```

## _tan


```lua
function
```

## _tanh


```lua
function
```

## _to_char


```lua
function
```

## _to_date


```lua
function
```

## _to_dsinterval


```lua
function
```

## _to_number


```lua
function
```

## _to_timestamp


```lua
function
```

## _to_yminterval


```lua
function
```

## _translate


```lua
function
```

## _trim


```lua
function
```

## _trunc


```lua
function
```

## _typeof


```lua
function
```

## _unicode


```lua
function
```

## _unicodechr


```lua
function
```

## _upper


```lua
function
```

## _week


```lua
function
```

## _year


```lua
function
```

## _years_between


```lua
function
```

## _zeroifnull


```lua
function
```

## append


```lua
function
```

 Alias for main appender function for uniform appender invocation

## append_scalar_function


```lua
(method) ScalarFunctionAppender:append_scalar_function(scalar_function: ScalarFunctionExpression)
```

 Append a scalar function to an SQL query.

@*param* `scalar_function` — function to append

## new


```lua
(method) ScalarFunctionAppender:new(out_query: Query, appender_config: AppenderConfig)
  -> renderer: ScalarFunctionAppender
```

 Create a new instance of a `ScalarFunctionAppender`.

@*param* `out_query` — query to which the function will be appended

@*return* `renderer` — for scalar functions


---

# ScalarFunctionExpression

## name


```lua
string
```


---

# SchemaMetadataInfo

Schema metadata info in requests

## adapterNotes


```lua
string?
```

## name


```lua
string
```

virtual schema name

## properties


```lua
table<string, string>
```


---

# SelectAppender

 Appender that can add top-level elements of a `SELECT` statement (or sub-select).

## DEFAULT_APPENDER_CONFIG


```lua
AppenderConfig
```

Default configuration with double quotes for identifiers.

## __index


```lua
SelectAppender
```

 Appender that can add top-level elements of a `SELECT` statement (or sub-select).

## _append


```lua
(method) AbstractQueryAppender:_append(token: string|number)
```

 Append a token to the query.

@*param* `token` — token to append

## _append_all


```lua
(method) AbstractQueryAppender:_append_all(...string|number)
```

 Append a list of tokens to the query.

@*param* `...` — to append

## _append_character_type


```lua
(method) AbstractQueryAppender:_append_character_type(data_type: CharacterTypeDefinition)
```

## _append_data_type


```lua
(method) AbstractQueryAppender:_append_data_type(data_type: BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4))
```

## _append_decimal_type_details


```lua
(method) AbstractQueryAppender:_append_decimal_type_details(data_type: DecimalTypeDefinition)
```

## _append_expression


```lua
(method) SelectAppender:_append_expression(expression: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4))
```

## _append_filter


```lua
(method) SelectAppender:_append_filter(filter: BetweenPredicate|BinaryPredicateExpression|ExistsPredicate|InPredicate|IteratedPredicate...(+4))
```

## _append_from


```lua
(method) SelectAppender:_append_from(from: JoinExpression|TableExpression)
```

## _append_geometry


```lua
(method) AbstractQueryAppender:_append_geometry(data_type: GeometryTypeDefinition)
```

## _append_group_by


```lua
(method) SelectAppender:_append_group_by(group?: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[])
```

## _append_hashtype


```lua
(method) AbstractQueryAppender:_append_hashtype(data_type: HashtypeTypeDefinition)
```

## _append_identifier


```lua
(method) AbstractQueryAppender:_append_identifier(identifier: string)
```

Append a quoted identifier, e.g. a schema, table or column name.

@*param* `identifier` — identifier

## _append_interval


```lua
(method) AbstractQueryAppender:_append_interval(data_type: IntervalTypeDefinition)
```

## _append_join


```lua
(method) SelectAppender:_append_join(join: JoinExpression)
```

## _append_limit


```lua
(method) SelectAppender:_append_limit(limit: LimitClause)
```

## _append_order_by


```lua
(method) SelectAppender:_append_order_by(order?: OrderByClause[], in_parenthesis?: boolean)
```

## _append_select_list


```lua
(method) SelectAppender:_append_select_list(select_list?: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[])
```

## _append_select_list_elements


```lua
(method) SelectAppender:_append_select_list_elements(select_list: ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[])
```

## _append_string_literal


```lua
(method) AbstractQueryAppender:_append_string_literal(literal: string)
```

 Append a string literal and enclose it in single quotes

@*param* `literal` — string literal

## _append_table


```lua
(method) SelectAppender:_append_table(table: TableExpression)
```

## _append_timestamp


```lua
(method) AbstractQueryAppender:_append_timestamp(data_type: TimestampTypeDefinition)
```

## _appender_config


```lua
AppenderConfig
```

configuration for the query renderer (e.g. containing identifier quoting)

## _comma


```lua
(method) AbstractQueryAppender:_comma(index: integer)
```

Append a comma in a comma-separated list where needed.
Appends a comma if the list index is greater than one.

@*param* `index` — position in the comma-separated list

## _expression_appender


```lua
(method) SelectAppender:_expression_appender()
  -> ExpressionAppender
```

## _init


```lua
(method) SelectAppender:_init(out_query: Query, appender_config: AppenderConfig)
```

## _out_query


```lua
Query
```

query object that the appender appends to

## append


```lua
function
```

 Alias for the main entry point allows uniform appender invocation

## append_select


```lua
(method) SelectAppender:append_select(sub_query: SelectSqlStatement)
```

 Append a `SELECT` statement.

@*param* `sub_query` — query appended

## append_sub_select


```lua
(method) SelectAppender:append_sub_select(sub_query: SelectSqlStatement)
```

 Append a sub-select statement.
 This method is public to allow recursive queries (e.g. embedded into an `EXISTS` clause in an expression.

@*param* `sub_query` — query appended

## get_join_types


```lua
function SelectAppender.get_join_types()
  -> join: table<string, string>
```

 Get a map of supported JOIN type to the join keyword.

@*return* `join` — type (key) mapped to SQL join keyword

## new


```lua
(method) SelectAppender:new(out_query: Query, appender_config: AppenderConfig)
  -> query: SelectAppender
```

 Create a new query renderer.

@*param* `out_query` — query structure as provided through the Virtual Schema API

@*return* `query` — renderer instance


---

# SelectList


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[]
```


---

# SelectSqlStatement

## aggregationType


```lua
(string|"single_group")?
```

## filter


```lua
(BetweenPredicate|BinaryPredicateExpression|ExistsPredicate|InPredicate|IteratedPredicate...(+4))?
```

 luacheck: max line length 180

## from


```lua
JoinExpression|TableExpression
```

## groupBy


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[]?
```

## having


```lua
any
```

## limit


```lua
any
```

## orderBy


```lua
OrderByClause[]?
```

## selectList


```lua
ColumnReference|LiteralBoolean|LiteralDate|LiteralDouble|LiteralExactNumeric...(+4)[][]?
```

## selectListDataTypes


```lua
BooleanTypeDefinition|CharacterTypeDefinition|DateTypeDefinition|DecimalTypeDefinition|DoubleTypeDefinition...(+4)[]
```

## type


```lua
"select"|"sub_select"
```


---

# SetPropertiesResponse

Response for a set properties request

## schemaMetadata


```lua
ExasolSchemaMetadata
```

Response for a createVirtualSchema request

## type


```lua
"setProperties"
```


---

# SourceType

```lua
SourceType:
    | "EXA"
    | "JDBC"
    | "ORA"
```


```lua
"EXA"|"JDBC"|"ORA"
```


---

# StringBasedLiteral


```lua
LiteralDate|LiteralInterval|LiteralString|LiteralTimestamp
```


---

# TableExpression

## catalog


```lua
string?
```

Optional catalog. Not used in Exasol useful for other databases that use catalogs.

## name


```lua
string
```

## schema


```lua
string?
```

## type


```lua
"table"
```


---

# TimestampTypeDefinition

## type


```lua
"TIMESTAMP"
```

## withLocalTimeZone


```lua
boolean
```


---

# Token


```lua
string|number
```


---

# UnaryPredicate


```lua
NotPredicate
```


---

# _G


A global variable (not a function) that holds the global environment (see [§2.2](command:extension.lua.doc?["en-us/54/manual.html/2.2"])). Lua itself does not use this variable; changing its value does not affect any environment, nor vice versa.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-_G"])



```lua
_G
```


---

# _VERSION


A global variable (not a function) that holds a string containing the running Lua version.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-_VERSION"])



```lua
string
```


---

# after_each

Define a function to run after each child test, this includes tests nested
in a child describe block.

## Example
```
describe("Test saving", function()
    local game

    after_each(function()
        game.save.reset()
    end)

    it("Creates game", function()
        game = game.new()
        game.save.save()
    end)

    describe("Saves metadata", function()
        it("Saves objects", function()
            game = game.new()
            game.save.save()
            assert.is_not.Nil(game.save.objects)
        end)
    end)
end)
```


```lua
function after_each(block: fun())
```


---

# arg


Command-line arguments of Lua Standalone.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-arg"])



```lua
string[]
```


---

# assert


Raises an error if the value of its argument v is false (i.e., `nil` or `false`); otherwise, returns all its arguments. In case of error, `message` is the error object; when absent, it defaults to `"assertion failed!"`

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-assert"])


```lua
unknown
```


```lua
function assert(v?: <T>, message?: any, ...any)
  -> <T>
  2. ...any
```


---

# async

Define the start of an asynchronous test.

Call `done()` at the end of your test to complete it.

## Example
```
it("Makes an http request", function()
    async()
    http.get("https://github.com", function()
        print("Got Website!")
        done()
    end)
end)
```


```lua
function async()
```


---

# before_each

Define a function to run before each child test, this includes tests nested
in a child describe block.

## Example
```
describe("Test Array Class", function()
    local a
    local b

    before_each(function()
        a = Array.new(1, 2, 3, 4)
        b = Array.new(11, 12, 13, 14)
    end)

    it("Assures instance is an Array", function()
        assert.True(Array.isArray(a))
        assert.True(Array.isArray(b))
    end)

    describe("Nested tests", function()
        it("Also runs before_each", function()
            assert.are.same(
                { 1, 2, 3, 4, 11, 12, 13, 14 },
                a:concat(b))
        end)
    end)
end)
```


```lua
function before_each(block: fun())
```


---

# collectgarbage


This function is a generic interface to the garbage collector. It performs different functions according to its first argument, `opt`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-collectgarbage"])


```lua
opt:
   -> "collect" -- Performs a full garbage-collection cycle.
    | "stop" -- Stops automatic execution.
    | "restart" -- Restarts automatic execution.
    | "count" -- Returns the total memory in Kbytes.
    | "step" -- Performs a garbage-collection step.
    | "isrunning" -- Returns whether the collector is running.
    | "incremental" -- Change the collector mode to incremental.
    | "generational" -- Change the collector mode to generational.
```


```lua
function collectgarbage(opt?: "collect"|"count"|"generational"|"incremental"|"isrunning"...(+3), ...any)
  -> any
```


---

# context


```lua
function
```


---

# coroutine




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine"])



```lua
coroutinelib
```


---

# coroutine.close


Closes coroutine `co` , closing all its pending to-be-closed variables and putting the coroutine in a dead state.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.close"])


```lua
function coroutine.close(co: thread)
  -> noerror: boolean
  2. errorobject: any
```


---

# coroutine.create


Creates a new coroutine, with body `f`. `f` must be a function. Returns this new coroutine, an object with type `"thread"`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.create"])


```lua
function coroutine.create(f: fun(...any):...unknown)
  -> thread
```


---

# coroutine.isyieldable


Returns true when the coroutine `co` can yield. The default for `co` is the running coroutine.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.isyieldable"])


```lua
function coroutine.isyieldable(co?: thread)
  -> boolean
```


---

# coroutine.resume


Starts or continues the execution of coroutine `co`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.resume"])


```lua
function coroutine.resume(co: thread, val1?: any, ...any)
  -> success: boolean
  2. ...any
```


---

# coroutine.running


Returns the running coroutine plus a boolean, true when the running coroutine is the main one.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.running"])


```lua
function coroutine.running()
  -> running: thread
  2. ismain: boolean
```


---

# coroutine.status


Returns the status of coroutine `co`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.status"])


```lua
return #1:
    | "running" -- Is running.
    | "suspended" -- Is suspended or not started.
    | "normal" -- Is active but not running.
    | "dead" -- Has finished or stopped with an error.
```


```lua
function coroutine.status(co: thread)
  -> "dead"|"normal"|"running"|"suspended"
```


---

# coroutine.wrap


Creates a new coroutine, with body `f`; `f` must be a function. Returns a function that resumes the coroutine each time it is called.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.wrap"])


```lua
function coroutine.wrap(f: fun(...any):...unknown)
  -> fun(...any):...unknown
```


---

# coroutine.yield


Suspends the execution of the calling coroutine.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.yield"])


```lua
(async) function coroutine.yield(...any)
  -> ...any
```


---

# debug




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug"])



```lua
debuglib
```


---

# debug.debug


Enters an interactive mode with the user, running each string that the user enters.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.debug"])


```lua
function debug.debug()
```


---

# debug.getfenv


Returns the environment of object `o` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getfenv"])


```lua
function debug.getfenv(o: any)
  -> table
```


---

# debug.gethook


Returns the current hook settings of the thread.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.gethook"])


```lua
function debug.gethook(co?: thread)
  -> hook: function
  2. mask: string
  3. count: integer
```


---

# debug.getinfo


Returns a table with information about a function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getinfo"])


---

```lua
what:
   +> "n" -- `name` and `namewhat`
   +> "S" -- `source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`
   +> "l" -- `currentline`
   +> "t" -- `istailcall`
   +> "u" -- `nups`, `nparams`, and `isvararg`
   +> "f" -- `func`
   +> "r" -- `ftransfer` and `ntransfer`
   +> "L" -- `activelines`
```


```lua
function debug.getinfo(thread: thread, f: integer|fun(...any):...unknown, what?: string|"L"|"S"|"f"|"l"...(+4))
  -> debuginfo
```


---

# debug.getlocal


Returns the name and the value of the local variable with index `local` of the function at level `f` of the stack.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getlocal"])


```lua
function debug.getlocal(thread: thread, f: integer|fun(...any):...unknown, index: integer)
  -> name: string
  2. value: any
```


---

# debug.getmetatable


Returns the metatable of the given value.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getmetatable"])


```lua
function debug.getmetatable(object: any)
  -> metatable: table
```


---

# debug.getregistry


Returns the registry table.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getregistry"])


```lua
function debug.getregistry()
  -> table
```


---

# debug.getupvalue


Returns the name and the value of the upvalue with index `up` of the function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getupvalue"])


```lua
function debug.getupvalue(f: fun(...any):...unknown, up: integer)
  -> name: string
  2. value: any
```


---

# debug.getuservalue


Returns the `n`-th user value associated
to the userdata `u` plus a boolean,
`false` if the userdata does not have that value.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getuservalue"])


```lua
function debug.getuservalue(u: userdata, n?: integer)
  -> any
  2. boolean
```


---

# debug.setcstacklimit


### **Deprecated in `Lua 5.4.2`**

Sets a new limit for the C stack. This limit controls how deeply nested calls can go in Lua, with the intent of avoiding a stack overflow.

In case of success, this function returns the old limit. In case of error, it returns `false`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setcstacklimit"])


```lua
function debug.setcstacklimit(limit: integer)
  -> boolean|integer
```


---

# debug.setfenv


Sets the environment of the given `object` to the given `table` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setfenv"])


```lua
function debug.setfenv(object: <T>, env: table)
  -> object: <T>
```


---

# debug.sethook


Sets the given function as a hook.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.sethook"])


---

```lua
mask:
   +> "c" -- Calls hook when Lua calls a function.
   +> "r" -- Calls hook when Lua returns from a function.
   +> "l" -- Calls hook when Lua enters a new line of code.
```


```lua
function debug.sethook(thread: thread, hook: fun(...any):...unknown, mask: string|"c"|"l"|"r", count?: integer)
```


---

# debug.setlocal


Assigns the `value` to the local variable with index `local` of the function at `level` of the stack.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setlocal"])


```lua
function debug.setlocal(thread: thread, level: integer, index: integer, value: any)
  -> name: string
```


---

# debug.setmetatable


Sets the metatable for the given value to the given table (which can be `nil`).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setmetatable"])


```lua
function debug.setmetatable(value: <T>, meta?: table)
  -> value: <T>
```


---

# debug.setupvalue


Assigns the `value` to the upvalue with index `up` of the function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setupvalue"])


```lua
function debug.setupvalue(f: fun(...any):...unknown, up: integer, value: any)
  -> name: string
```


---

# debug.setuservalue


Sets the given `value` as
the `n`-th user value associated to the given `udata`.
`udata` must be a full userdata.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setuservalue"])


```lua
function debug.setuservalue(udata: userdata, value: any, n?: integer)
  -> udata: userdata
```


---

# debug.traceback


Returns a string with a traceback of the call stack. The optional message string is appended at the beginning of the traceback.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.traceback"])


```lua
function debug.traceback(thread: thread, message?: any, level?: integer)
  -> message: string
```


---

# debug.upvalueid


Returns a unique identifier (as a light userdata) for the upvalue numbered `n` from the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.upvalueid"])


```lua
function debug.upvalueid(f: fun(...any):...unknown, n: integer)
  -> id: lightuserdata
```


---

# debug.upvaluejoin


Make the `n1`-th upvalue of the Lua closure `f1` refer to the `n2`-th upvalue of the Lua closure `f2`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.upvaluejoin"])


```lua
function debug.upvaluejoin(f1: fun(...any):...unknown, n1: integer, f2: fun(...any):...unknown, n2: integer)
```


---

# describe

Used to define a set of tests. Can be nested to define sub-tests.

## Example
```
describe("Test Item Class", function()
    it("Creates an item", function()
        --...
    end)
    describe("Test Tags", function()
        it("Creates a tag", function()
            --...
        end)
    end)
end)
```


```lua
function describe(name: string, block: fun())
```


---

# dofile


Opens the named file and executes its content as a Lua chunk. When called without arguments, `dofile` executes the content of the standard input (`stdin`). Returns all values returned by the chunk. In case of errors, `dofile` propagates the error to its caller. (That is, `dofile` does not run in protected mode.)

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-dofile"])


```lua
function dofile(filename?: string)
  -> ...any
```


---

# done

Mark the end of an asynchronous test.

Should be paired with a call to `async()`.


```lua
function done()
```


---

# error


Terminates the last protected function called and returns message as the error object.

Usually, `error` adds some information about the error position at the beginning of the message, if the message is a string.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-error"])


```lua
function error(message: any, level?: integer)
```


---

# expose

Functions like `describe()` except it exposes the test's environment to
outer contexts

## Example
```
describe("Test exposing", function()
    expose("Exposes a value", function()
        _G.myValue = 10
    end)

end)

describe("Another test in the same file", function()
    assert.are.equal(10, myValue)
end)
```


```lua
function expose(name: string, block: fun())
```


---

# file

Undocumented feature with unknown purpose.


```lua
function file(filename: string)
```


---

# finally

Runs last in a context block regardless of test outcome

## Example
```
it("Read File Contents",function()
    local f = io.open("file", "r")

    -- always close file after test
    finally(function()
        f:close()
    end)

    -- do stuff with f
end)
```


```lua
function finally(block: fun())
```


---

# getfenv


Returns the current environment in use by the function. `f` can be a Lua function or a number that specifies the function at that stack level.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-getfenv"])


```lua
function getfenv(f?: integer|fun(...any):...unknown)
  -> table
```


---

# getmetatable


If object does not have a metatable, returns nil. Otherwise, if the object's metatable has a __metatable field, returns the associated value. Otherwise, returns the metatable of the given object.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-getmetatable"])


```lua
function getmetatable(object: any)
  -> metatable: table
```


---

# insulate

Functions like `describe()` except it insulates the test's environment to
only this context.

This is the default behaviour of `describe()`.

## Example
```
describe("Test exposing", function()
    insulate("Insulates a value", function()
        _G.myValue = 10
    end)

end)

describe("Another test in the same file", function()
    assert.is.Nil(myValue)
end)
```


```lua
function insulate(name: string, block: fun())
```


---

# io




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io"])



```lua
iolib
```


---

# io.close


Close `file` or default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.close"])


```lua
exitcode:
    | "exit"
    | "signal"
```


```lua
function io.close(file?: file*)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


---

# io.flush


Saves any written data to default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.flush"])


```lua
function io.flush()
```


---

# io.input


Sets `file` as the default input file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.input"])


```lua
function io.input(file: string|file*)
```


---

# io.lines


------
```lua
for c in io.lines(filename, ...) do
    body
end
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.lines"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```


```lua
function io.lines(filename?: string, ...string|integer|"L"|"a"|"l"...(+1))
  -> fun():any, ...unknown
```


---

# io.open


Opens a file, in the mode specified in the string `mode`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.open"])


```lua
mode:
   -> "r" -- Read mode.
    | "w" -- Write mode.
    | "a" -- Append mode.
    | "r+" -- Update mode, all previous data is preserved.
    | "w+" -- Update mode, all previous data is erased.
    | "a+" -- Append update mode, previous data is preserved, writing is only allowed at the end of file.
    | "rb" -- Read mode. (in binary mode.)
    | "wb" -- Write mode. (in binary mode.)
    | "ab" -- Append mode. (in binary mode.)
    | "r+b" -- Update mode, all previous data is preserved. (in binary mode.)
    | "w+b" -- Update mode, all previous data is erased. (in binary mode.)
    | "a+b" -- Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)
```


```lua
function io.open(filename: string, mode?: "a"|"a+"|"a+b"|"ab"|"r"...(+7))
  -> file*?
  2. errmsg: string?
```


---

# io.output


Sets `file` as the default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.output"])


```lua
function io.output(file: string|file*)
```


---

# io.popen


Starts program prog in a separated process.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.popen"])


```lua
mode:
    | "r" -- Read data from this program by `file`.
    | "w" -- Write data to this program by `file`.
```


```lua
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
```


---

# io.read


Reads the `file`, according to the given formats, which specify what to read.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.read"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```


```lua
function io.read(...string|integer|"L"|"a"|"l"...(+1))
  -> any
  2. ...any
```


---

# io.tmpfile


In case of success, returns a handle for a temporary file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.tmpfile"])


```lua
function io.tmpfile()
  -> file*
```


---

# io.type


Checks whether `obj` is a valid file handle.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.type"])


```lua
return #1:
    | "file" -- Is an open file handle.
    | "closed file" -- Is a closed file handle.
    | `nil` -- Is not a file handle.
```


```lua
function io.type(file: file*)
  -> "closed file"|"file"|`nil`
```


---

# io.write


Writes the value of each of its arguments to default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"])


```lua
function io.write(...any)
  -> file*
  2. errmsg: string?
```


---

# ipairs


Returns three values (an iterator function, the table `t`, and `0`) so that the construction
```lua
    for i,v in ipairs(t) do body end
```
will iterate over the key–value pairs `(1,t[1]), (2,t[2]), ...`, up to the first absent index.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-ipairs"])


```lua
function ipairs(t: <T:table>)
  -> fun(table: <V>[], i?: integer):integer, <V>
  2. <T:table>
  3. i: integer
```


---

# it

Define a test that will pass, fail, or error.

You can also use `spec()` and `test()` as aliases.

## Example
```
describe("Test something", function()
    it("Runs a test", function()
        assert.is.True(10 == 10)
    end)
end)
```


```lua
function it(name: string, block: fun())
```


---

# lazy_setup

Runs first in a context block before any tests. Only runs if there are child
tests to run.

## Example
```
describe("Test something", function()
    local helper

    -- Will not run because there are no tests
    lazy_setup(function()
         helper = require("helper")
    end)

end)
```


```lua
function lazy_setup(block: fun())
```


---

# lazy_teardown

Runs last in a context block after all tests.

Will only run if tests were run in this context.

## Example
```
describe("Remove persistent value", function()
    local persist

    -- Will not run because no tests were run
    lazy_teardown(function()
         persist = nil
    end)

end)
```


```lua
function lazy_teardown(block: fun())
```


---

# load


Loads a chunk.

If `chunk` is a string, the chunk is this string. If `chunk` is a function, `load` calls it repeatedly to get the chunk pieces. Each call to `chunk` must return a string that concatenates with previous results. A return of an empty string, `nil`, or no value signals the end of the chunk.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-load"])


```lua
mode:
    | "b" -- Only binary chunks.
    | "t" -- Only text chunks.
   -> "bt" -- Both binary and text.
```


```lua
function load(chunk: string|function, chunkname?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadfile


Loads a chunk from file `filename` or from the standard input, if no file name is given.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-loadfile"])


```lua
mode:
    | "b" -- Only binary chunks.
    | "t" -- Only text chunks.
   -> "bt" -- Both binary and text.
```


```lua
function loadfile(filename?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadstring


Loads a chunk from the given string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-loadstring"])


```lua
function loadstring(text: string, chunkname?: string)
  -> function?
  2. error_message: string?
```


---

# math




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math"])



```lua
mathlib
```


---

# math.abs


Returns the absolute value of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.abs"])


```lua
function math.abs(x: <Number:number>)
  -> <Number:number>
```


---

# math.acos


Returns the arc cosine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.acos"])


```lua
function math.acos(x: number)
  -> number
```


---

# math.asin


Returns the arc sine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.asin"])


```lua
function math.asin(x: number)
  -> number
```


---

# math.atan


Returns the arc tangent of `y/x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan"])


```lua
function math.atan(y: number, x?: number)
  -> number
```


---

# math.atan2


Returns the arc tangent of `y/x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan2"])


```lua
function math.atan2(y: number, x: number)
  -> number
```


---

# math.ceil


Returns the smallest integral value larger than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ceil"])


```lua
function math.ceil(x: number)
  -> integer
```


---

# math.cos


Returns the cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cos"])


```lua
function math.cos(x: number)
  -> number
```


---

# math.cosh


Returns the hyperbolic cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cosh"])


```lua
function math.cosh(x: number)
  -> number
```


---

# math.deg


Converts the angle `x` from radians to degrees.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.deg"])


```lua
function math.deg(x: number)
  -> number
```


---

# math.exp


Returns the value `e^x` (where `e` is the base of natural logarithms).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.exp"])


```lua
function math.exp(x: number)
  -> number
```


---

# math.floor


Returns the largest integral value smaller than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.floor"])


```lua
function math.floor(x: number)
  -> integer
```


---

# math.fmod


Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.fmod"])


```lua
function math.fmod(x: number, y: number)
  -> number
```


---

# math.frexp


Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.frexp"])


```lua
function math.frexp(x: number)
  -> m: number
  2. e: number
```


---

# math.ldexp


Returns `m * (2 ^ e)` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ldexp"])


```lua
function math.ldexp(m: number, e: number)
  -> number
```


---

# math.log


Returns the logarithm of `x` in the given base.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log"])


```lua
function math.log(x: number, base?: integer)
  -> number
```


---

# math.log10


Returns the base-10 logarithm of x.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log10"])


```lua
function math.log10(x: number)
  -> number
```


---

# math.max


Returns the argument with the maximum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.max"])


```lua
function math.max(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.min


Returns the argument with the minimum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.min"])


```lua
function math.min(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.modf


Returns the integral part of `x` and the fractional part of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.modf"])


```lua
function math.modf(x: number)
  -> integer
  2. number
```


---

# math.pow


Returns `x ^ y` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.pow"])


```lua
function math.pow(x: number, y: number)
  -> number
```


---

# math.rad


Converts the angle `x` from degrees to radians.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.rad"])


```lua
function math.rad(x: number)
  -> number
```


---

# math.random


* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.random"])


```lua
function math.random(m: integer, n: integer)
  -> integer
```


---

# math.randomseed


* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.randomseed"])


```lua
function math.randomseed(x?: integer, y?: integer)
```


---

# math.sin


Returns the sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sin"])


```lua
function math.sin(x: number)
  -> number
```


---

# math.sinh


Returns the hyperbolic sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sinh"])


```lua
function math.sinh(x: number)
  -> number
```


---

# math.sqrt


Returns the square root of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sqrt"])


```lua
function math.sqrt(x: number)
  -> number
```


---

# math.tan


Returns the tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tan"])


```lua
function math.tan(x: number)
  -> number
```


---

# math.tanh


Returns the hyperbolic tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tanh"])


```lua
function math.tanh(x: number)
  -> number
```


---

# math.tointeger


Miss locale <math.tointeger>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tointeger"])


```lua
function math.tointeger(x: any)
  -> integer?
```


---

# math.type


Miss locale <math.type>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.type"])


```lua
return #1:
    | "integer"
    | "float"
    | 'nil'
```


```lua
function math.type(x: any)
  -> "float"|"integer"|'nil'
```


---

# math.ult


Miss locale <math.ult>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ult"])


```lua
function math.ult(m: integer, n: integer)
  -> boolean
```


---

# mock


```lua
unknown
```


---

# module


Creates a module.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-module"])


```lua
function module(name: string, ...any)
```


---

# newproxy


```lua
function newproxy(proxy: boolean|table|userdata)
  -> userdata
```


---

# next


Allows a program to traverse all fields of a table. Its first argument is a table and its second argument is an index in this table. A call to `next` returns the next index of the table and its associated value. When called with `nil` as its second argument, `next` returns an initial index and its associated value. When called with the last index, or with `nil` in an empty table, `next` returns `nil`. If the second argument is absent, then it is interpreted as `nil`. In particular, you can use `next(t)` to check whether a table is empty.

The order in which the indices are enumerated is not specified, *even for numeric indices*. (To traverse a table in numerical order, use a numerical `for`.)

The behavior of `next` is undefined if, during the traversal, you assign any value to a non-existent field in the table. You may however modify existing fields. In particular, you may set existing fields to nil.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-next"])


```lua
function next(table: table<<K>, <V>>, index?: <K>)
  -> <K>?
  2. <V>?
```


---

# os




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os"])



```lua
oslib
```


---

# os.clock


Returns an approximation of the amount in seconds of CPU time used by the program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.clock"])


```lua
function os.clock()
  -> number
```


---

# os.date


Returns a string or a table containing date and time, formatted according to the given string `format`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.date"])


```lua
function os.date(format?: string, time?: integer)
  -> string|osdate
```


---

# os.difftime


Returns the difference, in seconds, from time `t1` to time `t2`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.difftime"])


```lua
function os.difftime(t2: integer, t1: integer)
  -> integer
```


---

# os.execute


Passes `command` to be executed by an operating system shell.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.execute"])


```lua
exitcode:
    | "exit"
    | "signal"
```


```lua
function os.execute(command?: string)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


---

# os.exit


Calls the ISO C function `exit` to terminate the host program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.exit"])


```lua
function os.exit(code?: boolean|integer, close?: boolean)
```


---

# os.getenv


Returns the value of the process environment variable `varname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.getenv"])


```lua
function os.getenv(varname: string)
  -> string?
```


---

# os.remove


Deletes the file with the given name.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.remove"])


```lua
function os.remove(filename: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.rename


Renames the file or directory named `oldname` to `newname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.rename"])


```lua
function os.rename(oldname: string, newname: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.setlocale


Sets the current locale of the program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.setlocale"])


```lua
category:
   -> "all"
    | "collate"
    | "ctype"
    | "monetary"
    | "numeric"
    | "time"
```


```lua
function os.setlocale(locale: string|nil, category?: "all"|"collate"|"ctype"|"monetary"|"numeric"...(+1))
  -> localecategory: string
```


---

# os.time


Returns the current time when called without arguments, or a time representing the local date and time specified by the given table.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.time"])


```lua
function os.time(date?: osdateparam)
  -> integer
```


---

# os.tmpname


Returns a string with a file name that can be used for a temporary file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.tmpname"])


```lua
function os.tmpname()
  -> string
```


---

# package




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package"])



```lua
packagelib
```


---

# package.config


A string describing some compile-time configurations for packages.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.config"])



```lua
string
```


---

# package.loaders


A table used by `require` to control how to load modules.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.loaders"])



```lua
table
```


---

# package.loadlib


Dynamically links the host program with the C library `libname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.loadlib"])


```lua
function package.loadlib(libname: string, funcname: string)
  -> any
```


---

# package.path


```lua
unknown
```


---

# package.preload.remotelog


```lua
function ()
  -> unknown
```


---

# package.searchers


A table used by `require` to control how to load modules.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.searchers"])



```lua
table
```


---

# package.searchpath


Searches for the given `name` in the given `path`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.searchpath"])


```lua
function package.searchpath(name: string, path: string, sep?: string, rep?: string)
  -> filename: string?
  2. errmsg: string?
```


---

# package.seeall


Sets a metatable for `module` with its `__index` field referring to the global environment, so that this module inherits values from the global environment. To be used as an option to function `module` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.seeall"])


```lua
function package.seeall(module: table)
```


---

# pairs


If `t` has a metamethod `__pairs`, calls it with t as argument and returns the first three results from the call.

Otherwise, returns three values: the [next](command:extension.lua.doc?["en-us/54/manual.html/pdf-next"]) function, the table `t`, and `nil`, so that the construction
```lua
    for k,v in pairs(t) do body end
```
will iterate over all key–value pairs of table `t`.

See function [next](command:extension.lua.doc?["en-us/54/manual.html/pdf-next"]) for the caveats of modifying the table during its traversal.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-pairs"])


```lua
function pairs(t: <T:table>)
  -> fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>
  2. <T:table>
```


---

# pcall


Calls the function `f` with the given arguments in *protected mode*. This means that any error inside `f` is not propagated; instead, `pcall` catches the error and returns a status code. Its first result is the status code (a boolean), which is true if the call succeeds without errors. In such case, `pcall` also returns all results from the call, after this first result. In case of any error, `pcall` returns `false` plus the error object.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-pcall"])


```lua
function pcall(f: fun(...any):...unknown, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```


---

# pending

Mark a test as placeholder.

This will not fail or pass, it will simply be marked as "pending".


```lua
function pending(name: string, block: fun())
```


---

# print


Receives any number of arguments and prints their values to `stdout`, converting each argument to a string following the same rules of [tostring](command:extension.lua.doc?["en-us/54/manual.html/pdf-tostring"]).
The function print is not intended for formatted output, but only as a quick way to show a value, for instance for debugging. For complete control over the output, use [string.format](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"]) and [io.write](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"]).


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-print"])


```lua
function print(...any)
```


---

# randomize

Randomize tests nested in this block.

## Example
```
describe("A randomized test", function()
    randomize()
    it("My order is random", function() end)
    it("My order is also random", function() end)
end)
```


```lua
function randomize()
```


---

# rawequal


Checks whether v1 is equal to v2, without invoking the `__eq` metamethod.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-rawequal"])


```lua
function rawequal(v1: any, v2: any)
  -> boolean
```


---

# rawget


Gets the real value of `table[index]`, without invoking the `__index` metamethod.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-rawget"])


```lua
function rawget(table: table, index: any)
  -> any
```


---

# rawlen


Returns the length of the object `v`, without invoking the `__len` metamethod.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-rawlen"])


```lua
function rawlen(v: string|table)
  -> len: integer
```


---

# rawset


Sets the real value of `table[index]` to `value`, without using the `__newindex` metavalue. `table` must be a table, `index` any value different from `nil` and `NaN`, and `value` any Lua value.
This function returns `table`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-rawset"])


```lua
function rawset(table: table, index: any, value: any)
  -> table
```


---

# require


Loads the given module, returns any value returned by the searcher(`true` when `nil`). Besides that value, also returns as a second result the loader data returned by the searcher, which indicates how `require` found the module. (For instance, if the module came from a file, this loader data is the file path.)

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-require"])


```lua
function require(modname: string)
  -> unknown
  2. loaderdata: unknown
```


---

# select


If `index` is a number, returns all arguments after argument number `index`; a negative number indexes from the end (`-1` is the last argument). Otherwise, `index` must be the string `"#"`, and `select` returns the total number of extra arguments it received.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-select"])


```lua
index:
    | "#"
```


```lua
function select(index: integer|"#", ...any)
  -> any
```


---

# setfenv


Sets the environment to be used by the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-setfenv"])


```lua
function setfenv(f: fun(...any):...integer|unknown, table: table)
  -> function
```


---

# setmetatable


Sets the metatable for the given table. If `metatable` is `nil`, removes the metatable of the given table. If the original metatable has a `__metatable` field, raises an error.

This function returns `table`.

To change the metatable of other types from Lua code, you must use the debug library ([§6.10](command:extension.lua.doc?["en-us/54/manual.html/6.10"])).


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-setmetatable"])


```lua
function setmetatable(table: table, metatable?: table|metatable)
  -> table
```


---

# setup

Runs first in a context block before any tests.

Will always run even if there are no child tests to run. If you don't want
them to run regardless, you can use `lazy_setup()` or use the `--lazy` flag
when running.

## Example
```
describe("Test something", function()
    local helper

    setup(function()
         helper = require("helper")
    end)

    it("Can use helper", function()
        assert.is_not.Nil(helper)
    end)
end)
```


```lua
function setup(block: fun())
```


---

# spec


```lua
function
```


---

# spy


```lua
unknown
```


---

# strict_setup


```lua
function
```


---

# strict_teardown


```lua
function
```


---

# string




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string"])



```lua
stringlib
```


---

# string.byte


Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.byte"])


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


---

# string.char


Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.char"])


```lua
function string.char(byte: integer, ...integer)
  -> string
```


---

# string.dump


Returns a string containing a binary representation (a *binary chunk*) of the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.dump"])


```lua
function string.dump(f: fun(...any):...unknown, strip?: boolean)
  -> string
```


---

# string.find


Looks for the first match of `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/54/manual.html/6.4.1"])) in the string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.find"])

@*return* `start`

@*return* `end`

@*return* `...` — captured


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer|nil
  2. end: integer|nil
  3. ...any
```


---

# string.format


Returns a formatted version of its variable number of arguments following the description given in its first argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"])


```lua
function string.format(s: string|number, ...any)
  -> string
```


---

# string.gmatch


Returns an iterator function that, each time it is called, returns the next captures from `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/54/manual.html/6.4.1"])) over the string s.

As an example, the following loop will iterate over all the words from string s, printing one per line:
```lua
    s =
"hello world from Lua"
    for w in string.gmatch(s, "%a+") do
        print(w)
    end
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gmatch"])


```lua
function string.gmatch(s: string|number, pattern: string|number, init?: integer)
  -> fun():string, ...unknown
```


---

# string.gsub


Returns a copy of s in which all (or the first `n`, if given) occurrences of the `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/54/manual.html/6.4.1"])) have been replaced by a replacement string specified by `repl`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gsub"])


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


---

# string.len


Returns its length.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.len"])


```lua
function string.len(s: string|number)
  -> integer
```


---

# string.lower


Returns a copy of this string with all uppercase letters changed to lowercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.lower"])


```lua
function string.lower(s: string|number)
  -> string
```


---

# string.match


Looks for the first match of `pattern` (see [§6.4.1](command:extension.lua.doc?["en-us/54/manual.html/6.4.1"])) in the string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.match"])


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


---

# string.pack


Returns a binary string containing the values `v1`, `v2`, etc. packed (that is, serialized in binary form) according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.pack"])


```lua
function string.pack(fmt: string, v1: string|number, v2?: string|number, ...string|number)
  -> binary: string
```


---

# string.packsize


Returns the size of a string resulting from `string.pack` with the given format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.packsize"])


```lua
function string.packsize(fmt: string)
  -> integer
```


---

# string.rep


Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.rep"])


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


---

# string.reverse


Returns a string that is the string `s` reversed.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.reverse"])


```lua
function string.reverse(s: string|number)
  -> string
```


---

# string.sub


Returns the substring of the string that starts at `i` and continues until `j`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.sub"])


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


---

# string.unpack


Returns the values packed in string according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.unpack"])


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
  2. offset: integer
```


---

# string.upper


Returns a copy of this string with all lowercase letters changed to uppercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.upper"])


```lua
function string.upper(s: string|number)
  -> string
```


---

# stub


```lua
unknown
```


---

# table




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table"])



```lua
tablelib
```


---

# table.concat


Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.concat"])


```lua
function table.concat(list: table, sep?: string, i?: integer, j?: integer)
  -> string
```


---

# table.foreach


Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreach"])


```lua
function table.foreach(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.foreachi


Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreachi"])


```lua
function table.foreachi(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.getn


Returns the number of elements in the table. This function is equivalent to `#list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.getn"])


```lua
function table.getn(list: <T>[])
  -> integer
```


---

# table.insert


Inserts element `value` at position `pos` in `list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.insert"])


```lua
function table.insert(list: table, pos: integer, value: any)
```


---

# table.maxn


Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.maxn"])


```lua
function table.maxn(table: table)
  -> integer
```


---

# table.move


Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.move"])


```lua
function table.move(a1: table, f: integer, e: integer, t: integer, a2?: table)
  -> a2: table
```


---

# table.pack


Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.pack"])


```lua
function table.pack(...any)
  -> table
```


---

# table.remove


Removes from `list` the element at position `pos`, returning the value of the removed element.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.remove"])


```lua
function table.remove(list: table, pos?: integer)
  -> any
```


---

# table.sort


Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.sort"])


```lua
function table.sort(list: <T>[], comp?: fun(a: <T>, b: <T>):boolean)
```


---

# table.unpack


Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.unpack"])


```lua
function table.unpack(list: <T>[], i?: integer, j?: integer)
  -> ...<T>
```


---

# teardown

Runs last in a context block after all tests.

Will run ever if no tests were run in this context. If you don't want this
to run regardless, you can use `lazy_teardown()` or use the `--lazy` flag
when running.

## Example
```
describe("Remove persistent value", function()
    local persist

    it("Sets a persistent value", function()
        persist = "hello"
    end)

    teardown(function()
         persist = nil
    end)

end)
```


```lua
function teardown(block: fun())
```


---

# test


```lua
function
```


---

# tonumber


When called with no `base`, `tonumber` tries to convert its argument to a number. If the argument is already a number or a string convertible to a number, then `tonumber` returns this number; otherwise, it returns `fail`.

The conversion of strings can result in integers or floats, according to the lexical conventions of Lua (see [§3.1](command:extension.lua.doc?["en-us/54/manual.html/3.1"])). The string may have leading and trailing spaces and a sign.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-tonumber"])


```lua
function tonumber(e: any)
  -> number?
```


---

# tostring


Receives a value of any type and converts it to a string in a human-readable format.

If the metatable of `v` has a `__tostring` field, then `tostring` calls the corresponding value with `v` as argument, and uses the result of the call as its result. Otherwise, if the metatable of `v` has a `__name` field with a string value, `tostring` may use that string in its final result.

For complete control of how numbers are converted, use [string.format](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"]).


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-tostring"])


```lua
function tostring(v: any)
  -> string
```


---

# type


Returns the type of its only argument, coded as a string. The possible results of this function are `"nil"` (a string, not the value `nil`), `"number"`, `"string"`, `"boolean"`, `"table"`, `"function"`, `"thread"`, and `"userdata"`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-type"])


```lua
type:
    | "nil"
    | "number"
    | "string"
    | "boolean"
    | "table"
    | "function"
    | "thread"
    | "userdata"
```


```lua
function type(v: any)
  -> type: "boolean"|"function"|"nil"|"number"|"string"...(+3)
```


---

# unpack


Returns the elements from the given `list`. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-unpack"])


```lua
function unpack(list: <T>[], i?: integer, j?: integer)
  -> ...<T>
```


```lua
function unpack(list: { [1]: <T1>, [2]: <T2>, [3]: <T3>, [4]: <T4>, [5]: <T5>, [6]: <T6>, [7]: <T7>, [8]: <T8>, [9]: <T9> })
  -> <T1>
  2. <T2>
  3. <T3>
  4. <T4>
  5. <T5>
  6. <T6>
  7. <T7>
  8. <T8>
  9. <T9>
```


---

# utf8




[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8"])



```lua
utf8lib
```


---

# utf8.char


Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.char"])


```lua
function utf8.char(code: integer, ...integer)
  -> string
```


---

# utf8.codepoint


Returns the codepoints (as integers) from all characters in `s` that start between byte position `i` and `j` (both included).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.codepoint"])


```lua
function utf8.codepoint(s: string, i?: integer, j?: integer, lax?: boolean)
  -> code: integer
  2. ...integer
```


---

# utf8.codes


Returns values so that the construction
```lua
for p, c in utf8.codes(s) do
    body
end
```
will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.codes"])


```lua
function utf8.codes(s: string, lax?: boolean)
  -> fun(s: string, p: integer):integer, integer
```


---

# utf8.len


Returns the number of UTF-8 characters in string `s` that start between positions `i` and `j` (both inclusive).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.len"])


```lua
function utf8.len(s: string, i?: integer, j?: integer, lax?: boolean)
  -> integer?
  2. errpos: integer?
```


---

# utf8.offset


Returns the position (in bytes) where the encoding of the `n`-th character of `s` (counting from position `i`) starts.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.offset"])


```lua
function utf8.offset(s: string, n: integer, i?: integer)
  -> p: integer
```


---

# warn


Emits a warning with a message composed by the concatenation of all its arguments (which should be strings).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-warn"])


```lua
function warn(message: string, ...any)
```


---

# xpcall


Calls function `f` with the given arguments in protected mode with a new message handler.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-xpcall"])


```lua
function xpcall(f: fun(...any):...unknown, msgh: function, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```
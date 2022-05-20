# virtual-schema-common-lua 1.0.0, released 2022-04-08
 
Code name: Initial release
 
## Summary

Extracted the base library for Lua-powered Virtual Schemas from [`row-level-security-lua`](https://github.com/exasol/row-level-security-lua).

Note that `virtual-schame-common-lua` has dependencies to `cjson` and `luasockets`, both of which are pre-installed on Exasol.

## Features / Enhancements
 
* #1: Migrated from `row-level-security-lua`

## Documentation

* #5: Updated developer guide with LuaRocks and EmmyLua tips
* #12: Traced requirements down to implementation and test

## Refactoring

* #4: Added CI build
* #7: Added missing abstract methods in `AbstractVirtualSchemaAdapter`
* #9: Added Workaround for (x)pcall problem in core database

## Dependency Updates

### Compile Dependency Updates

* Added `com.exasol:maven-project-version-getter:1.0.0`

### Test Dependency Updates

* Added `com.exasol:exasol-jdbc:7.1.2`
* Added `com.exasol:exasol-testcontainers:5.1.1`
* Added `com.exasol:hamcrest-resultset-matcher:1.5.1`
* Added `com.exasol:test-db-builder-java:3.2.1`
* Added `org.hamcrest:hamcrest:2.2`
* Added `org.junit.jupiter:junit-jupiter-engine:5.7.2`
* Added `org.junit.jupiter:junit-jupiter-params:5.7.2`
* Added `org.junit.platform:junit-platform-runner:1.7.2`
* Added `org.slf4j:slf4j-jdk14:1.7.32`
* Added `org.testcontainers:junit-jupiter:1.16.2`

### Plugin Dependency Updates

* Added `com.exasol:error-code-crawler-maven-plugin:0.1.1`
* Added `com.exasol:project-keeper-maven-plugin:1.3.2`
* Added `io.github.zlika:reproducible-build-maven-plugin:0.13`
* Added `org.apache.maven.plugins:maven-clean-plugin:2.5`
* Added `org.apache.maven.plugins:maven-compiler-plugin:3.8.1`
* Added `org.apache.maven.plugins:maven-deploy-plugin:2.7`
* Added `org.apache.maven.plugins:maven-enforcer-plugin:3.0.0-M3`
* Added `org.apache.maven.plugins:maven-failsafe-plugin:3.0.0-M4`
* Added `org.apache.maven.plugins:maven-install-plugin:2.4`
* Added `org.apache.maven.plugins:maven-jar-plugin:3.2.0`
* Added `org.apache.maven.plugins:maven-resources-plugin:2.6`
* Added `org.apache.maven.plugins:maven-site-plugin:3.3`
* Added `org.apache.maven.plugins:maven-surefire-plugin:3.0.0-M4`
* Added `org.codehaus.mojo:build-helper-maven-plugin:3.2.0`
* Added `org.codehaus.mojo:exec-maven-plugin:3.0.0`
* Added `org.codehaus.mojo:versions-maven-plugin:2.7`
* Added `org.itsallcode:openfasttrace-maven-plugin:1.4.0`
* Added `org.jacoco:jacoco-maven-plugin:0.8.5`
* Added `org.sonatype.ossindex.maven:ossindex-maven-plugin:3.1.0`

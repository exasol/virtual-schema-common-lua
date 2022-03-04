# Developer Guide

## Preparation

Before you can build and test the application, you need to install Lua packages on the build machine.

### Installing LuaRocks

First install the package manager LuaRocks.

```bash
sudo apt install luarocks
```

Now update your `LUA_PATH`, so that it contains the packages (aka. "rocks"). You can auto-generate that path.

```bash
luarocks path
```

Of course generating it is not enough, you also need to make sure the export is actually executed &mdash; preferably automatically each time. Here is an example that appends the path to the `.bashrc`:

```bash
luarocks path >> ~/.bashrc
```

### Installing the Required Lua Packages

You need the packages for unit testing, mocking and JSON processing.

Execute as `root` or modify to install in your home directory:

```bash
sudo luarocks install LuaUnit
sudo luarocks install Mockagne
sudo luarocks install lua-cjson
sudo luarocks install remotelog
sudo luarocks install luacov
sudo luarocks install luacov-coveralls
sudo luarocks install luacheck
```

Most of those packages are only required for testing. While `cjson` is needed at runtime, it is prepackaged with Exasol, so no need to install it at runtime.

The `luacov` and `luacov-coveralls` libraries take care of measuring and reporting code coverage in the tests.

## How to Run Lua Unit Tests

### Run Unit Tests From Terminal

To run unit tests from terminal, you first need to install Lua:

```bash
sudo apt install lua5.1
```

Another important thing to do, you need to add the project's directories with lua files to LUA_PATH environment variable.
We add two absolute paths, one to the `main` and another to the `test` folder: 

```bash
export LUA_PATH='/home/<absolute>/<path>/row-level-security-lua/src/main/lua/?.lua;/home/<absolute>/<path>/row-level-security-lua/src/test/lua/?.lua;'"$LUA_PATH"
```

After that you can try to run any test file:

```bash
lua src/test/lua/exasolvs/test_query_renderer.lua 
```

If you want to run all unit tests including code coverage and static code analysis, issue the following command:

```bash
tools/runtests.sh
```

The test output contains summaries and you will find reports in the `luaunit-reports` and `luacov-reports` directories.

### Understanding the Sources

Under [doc/model](../../model) you find a UML model of the project that you can render with [PlantUML](https://plantuml.com/). We recommend studying the model to understand structure and behavior.

You can render the model by running:

```bash
mvn com.github.jeluard:plantuml-maven-plugin:generate
```

The resulting SVG files are located under [target/plantuml](../../target/plantuml). They contain links for drilling down.

Since the model contains all imporant information, here just a very short summary.

1. VSCL provides a base library for writing your own Virtual Schemas in Lua
1. The resulting package is available as LuaRocks package `virtual-schema-common-lua`
1. In your concrete Virtual Schema implementation you need to write an `entry` module, that has an `adapter_call` entry function
1. The `entry` module should create and wire up all static objects (like the `RequestDispatcher` for example)
1. Use the `remotelog` package for logging

### Running the Unit Tests From Intellij IDEA

First, you need to install a plug-in that handles Lua code. We recommend to use `lua` plugin by `sylvanaar`.

In the next step we add a Lua interpreter. Fow that go to `File` &rarr; `Project structure` &rarr; `Modules`.
Here press `Add` button in the upper left corner and add a new Lua framework.
You can use one of the default Lua interpreters suggested by Intellij or add your own in `SDKs` tab of the `Project structure`.
We recommend installing and using `lua5.1`.

Now add the `LUA_PATH` environment variable here too. Go to `Run` &rarr; `Edit configurations` &rarr; `Templates` &rarr; `Lua Script`.
We assume that you have already run the tests via a terminal and you added an environment variable there. Now check it via a terminal command:

```bash
echo $LUA_PATH
```

Copy the output, in the `Environment variables` field press `Browse` &rarr; `Add`.
Paste the lines you copied to the `Value` field and add `LUA_PATH` as a `Name`.
  
Now you can right-click any unit-test class and `Run...` or use hot keys `[CTRL] + [SHIFT] + [F10]`.

### Running the Unit Tests From Eclipse IDE

We recommend you install the [Lua Development Tools (LDT)](https://www.eclipse.org/ldt/) when working on this project using the Eclipse IDE. If you add the Lua nature to the project, you can set the paths `src/main/lua` and `src/test/lua` as source paths. This way you can directly run the unit test as Lua application (`[CTRL] + [F11]`) without further configuration.

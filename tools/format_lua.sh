#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly src_module_path="$base_dir/src"
readonly test_module_path="$base_dir/spec"

lua-format --config="$base_dir/.lua-format" --verbose --in-place -- \
  "$src_module_path"/exasol/vscl/*.lua \
  "$src_module_path"/exasol/vscl/queryrenderer/*.lua \
  "$test_module_path"/assertions/*.lua \
  "$test_module_path"/exasol/vscl/*.lua \
  "$test_module_path"/exasol/vscl/queryrenderer/*.lua

"$base_dir/tools/run_luacheck.sh"

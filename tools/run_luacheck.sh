#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

# Ignore methods that don't use the 'self' argument. This is for example required to return constants.
readonly ignores="--ignore 212"

readonly src_module_path="$base_dir/src"
readonly test_module_path="$base_dir/spec"

luacheck "$src_module_path" --max-line-length 120 --codes $ignores

luacheck "$test_module_path" --max-line-length 120 --codes
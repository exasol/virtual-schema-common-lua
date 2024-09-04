#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

find "$base_dir/tools" -name '*.sh' -type f -print0 | xargs -0 -n1 shellcheck -x

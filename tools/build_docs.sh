#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly target_dir="$base_dir/target"
readonly language_server_dir="$target_dir/luals"
readonly language_server_executable="$language_server_dir/bin/lua-language-server"
readonly type_check_log_dir="$target_dir/type-checker-logs"

# Install luals on demand (skips installation if present)
"$base_dir/tools/install-luals.sh"

readonly doc_path="$target_dir/luals-doc"
mkdir -p "$doc_path"
echo "Generating API doc in $doc_path..."
if ! "$language_server_executable" --doc="$base_dir" --loglevel=trace --logpath="$type_check_log_dir" --doc_out_path="$doc_path" ; then
    echo "Type check failed with return code $?"
    exit 1
fi

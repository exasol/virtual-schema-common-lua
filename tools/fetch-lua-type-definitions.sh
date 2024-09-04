#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly type_def_dir="$base_dir/target/lua-type-definitions"
mkdir --parent "$type_def_dir"

function clone_repo() {
    local repo_url="$1"
    local repo_name="$2"
    local dir_path="$type_def_dir/$repo_name"
    if [ ! -d "$dir_path" ]; then
        echo "Cloning $repo_url to $dir_path"
        git clone --depth 1 "$repo_url" "$dir_path"
    else
        echo "Directory $dir_path already exists."
        git -C "$dir_path" pull
    fi
}

clone_repo https://github.com/LuaCATS/busted.git busted

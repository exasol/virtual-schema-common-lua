#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly language_server_version="3.19.1"

# Check if os is mac or linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    architecture="darwin-x64"
    language_server_version_sha256="eb373c159cbe556711d7cd316315de2dce969bfd54b31edb7eb9cab2937f2cca"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    architecture="linux-x64"
    language_server_version_sha256="e9235d2d72ef55bc41cf8c99cda2ed64777682024b4bb81f5dea425060c5cbb8"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

readonly architecture
readonly language_server_version_sha256

readonly language_server_url="https://github.com/LuaLS/lua-language-server/releases/download/${language_server_version}/lua-language-server-${language_server_version}-${architecture}.tar.gz"
readonly target_dir="$base_dir/target"
readonly language_server_archive="$target_dir/luals-$language_server_version-$architecture.tar.gz"
readonly language_server_dir="$target_dir/luals"
readonly language_server_executable="$language_server_dir/bin/lua-language-server"

if [ ! -d "$base_dir/target/lua-type-definitions" ]; then
    echo "Lua type definitions are missing, fetching them..."
    "$base_dir/tools/fetch-lua-type-definitions.sh"
fi

if [ ! -f "$language_server_archive" ]; then
    echo "Downloading from $language_server_url"
    wget --no-verbose --output-document="$language_server_archive" "$language_server_url"
fi

if ! echo "$language_server_version_sha256 $language_server_archive" | sha256sum --check --status; then
    echo "SHA256 checksum mismatch for $language_server_archive. Expected $language_server_version_sha256 but actual checksum is:"
    sha256sum "$language_server_archive"
    ls -l "$language_server_archive"
    exit 1
fi

if [ ! -f "$language_server_executable" ]; then
    echo "Extracting $language_server_archive to $language_server_dir"
    mkdir -p "$language_server_dir"
    tar -xzf "$language_server_archive" --directory "$language_server_dir"
fi

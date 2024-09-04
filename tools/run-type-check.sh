#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly language_server_version="3.10.5"
readonly type_check_level="Error" # Error, Warning, Information, Hint

# Check if os is mac or linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    architecture="darwin-x64"
    language_server_version_sha256="a1986521f9a2e1998d37341ece89cabcb9a7d8c8d4a837123f424519366452a7"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    architecture="linux-x64"
    language_server_version_sha256="7ed04e25d83d89217f8acd4e0ff657e4d5a66550322555721bf5195f223b7f96"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

readonly architecture
readonly language_server_version_sha256

readonly language_server_url="https://github.com/LuaLS/lua-language-server/releases/download/${language_server_version}/lua-language-server-${language_server_version}-${architecture}.tar.gz"
readonly target_dir="$base_dir/target"
readonly language_server_archive="$target_dir/luals-$language_server_version-$architecture.tar.gz"
readonly language_server_dir="$target_dir/lua-ls-$language_server_version-$architecture"
readonly language_server_executable="$language_server_dir/bin/lua-language-server"
readonly type_check_log_dir="$target_dir/type-checker-logs"

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

echo "Running type check using $language_server_executable..."
type_check_result_json="$type_check_log_dir"/check.json

if ! "$language_server_executable" --check="$base_dir" --loglevel=trace --logpath="$type_check_log_dir" --checklevel="$type_check_level" ; then
    echo "Type check failed with return code $?"
fi

function evaluate_json_report_github_actions() {
    # Based on https://github.com/LuaLS/lua-language-server/issues/2830#issuecomment-2315627616
    jq -r '
        to_entries[] |
          (.key | sub("^.*?\\./"; "")) as $file | 
        .value[] |
          .code as $title |
          (.range.start.line + 1) as $line |
          (.range.start.character + 1) as $col |
          .message as $message |
        "\($file):\($line):\($col)::\($message)\n" +
        "::error file=\($file),line=\($line),col=\($col),title=\($title)::\($message)"
    ' "${type_check_result_json}"
}

function evaluate_json_report_human_readable() {
    jq -r '
        to_entries[] |
          (.key | sub("^.*?\\./"; "")) as $file | 
        .value[] |
          .code as $title |
          (.range.start.line + 1) as $line |
          (.range.start.character + 1) as $col |
          .message as $message |
        "\($file):\($line):\($col) \($title): \($message)"
    ' "${type_check_result_json}"
}

if [ -n "${GITHUB_ACTIONS:-}" ]; then
    evaluate_json_report_github_actions
else
    evaluate_json_report_human_readable
fi


if [ "$(jq -r 'length' "${type_check_result_json}")" -gt 0 ]; then
    echo "Type check failed, see messages above for details."
    exit 1
else
    echo "Type check passed"
fi

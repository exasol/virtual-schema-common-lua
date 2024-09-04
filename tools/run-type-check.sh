#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

base_dir="$( cd "$(dirname "$0")/.." >/dev/null 2>&1 ; pwd -P )"
readonly base_dir

readonly type_check_level="Error" # Error, Warning, Information, Hint

readonly target_dir="$base_dir/target"
readonly language_server_dir="$target_dir/luals"
readonly language_server_executable="$language_server_dir/bin/lua-language-server"
readonly type_check_log_dir="$target_dir/type-checker-logs"
readonly type_check_result_json="$type_check_log_dir"/check.json

"$base_dir/tools/install-luals.sh"

echo "Running type check using $language_server_executable..."
if ! "$language_server_executable" --check="$base_dir" --loglevel=trace --logpath="$type_check_log_dir" --checklevel="$type_check_level" ; then
    echo "Type check failed with return code $?"
    exit 1
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

#!/bin/sh
printf '\033c\033]0;%s\a' bouncy
base_path="$(dirname "$(realpath "$0")")"
"$base_path/bouncy.x86_64" "$@"

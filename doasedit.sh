#!/usr/bin/env sh

set -euo pipefail

file=$1

temp=$(mktemp doasedit.XXXXX)
cp "$file" "$temp"
$EDITOR "$temp"
doas mv "$temp" "$file"

#!/usr/bin/env sh

set -eu

file=$1

temp=$(mktemp doasedit.XXXXX)
cp "$file" "$temp"
# Ensure we get a chance to enter password first. Assumes persist is enabled.
doas true
$EDITOR "$temp"
# cp over mv to maintain metadata
doas cp "$temp" "$file"
rm "$temp"

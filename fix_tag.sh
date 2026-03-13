#!/usr/bin/env bash

set -eo pipefail

tag=$(dmenu -p "Tag:" </dev/null)
[ -z "$tag" ] && exit

result=$(prefix --tag "$tag")
if [ "$result" != "$tag" ]; then
    notify-send "'$tag' = $result"
else
    notify-send "'$tag' does not match any tags"
fi

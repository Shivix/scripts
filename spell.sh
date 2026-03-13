#!/usr/bin/env bash

set -eo pipefail

word=$(dmenu -p "Spell check:" </dev/null)
[ -z "$word" ] && exit

suggestions=$(echo "$word" | aspell -a | tail -n +2 | sed -n 's/^& [^:]*: //p' | sed 's/, /\n/g')
if [ -z "$suggestions" ]; then
    notify-send "'$word' is correct"
    exit
fi

correction=$(echo "$suggestions" | dmenu -p "Replace '$word' with:")
[ -n "$correction" ] && printf %s "$correction" | xsel -ib

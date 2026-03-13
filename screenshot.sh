#!/usr/bin/env bash

set -eo pipefail

input=$(dmenu -p "File Name:" </dev/null)

if [ -z "$input" ]; then
    exit
fi

image_path="$HOME/Pictures/$input.png"

if [ -e "$image_path" ]; then
    notify-send "File name already exists"
    exit
fi

maim -s -u "$image_path"

feh "$image_path"

#!/usr/bin/env bash

set -eo pipefail

book=$(ls ~/Documents/Books | dmenu -i)
[ -z "$book" ] && exit

zathura $(fd "$book" ~/Documents/Books)

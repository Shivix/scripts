#!/usr/bin/env bash

set -eo pipefail

book=$(ls ~/Documents/Books | dmenu)
[ -z "$book" ] && exit

zathura $(fd "$book" ~/Documents/Books)

#!/usr/bin/env bash

set -eo pipefail

session_name="main_kak_session"

if ! kak -l | grep -Fxq "$session_name"; then
    setsid kak -d -s "$session_name" &
    sleep 0.1
fi

kak -c "$session_name" "$@"

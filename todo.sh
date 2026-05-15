#!/usr/bin/env sh

set -eu

TODO_FILE="$HOME/.local/state/todo.txt"

cmd=${1:-}
if [ -n "$cmd" ]; then
    shift
fi

case "$cmd" in
    "")
        nl -w1 -s") " "$TODO_FILE"
        ;;
    add|a)
        echo "$*" >>$TODO_FILE
        ;;
    edit|e)
        $EDITOR "$TODO_FILE"
        ;;
    remove|r|delete|d)
        if [ $# -ne 1 ]; then
            echo "$cmd takes a single argument" >&2
            exit 1
        fi
        case "$1" in
            ''|*[!0-9]*)
                echo "invalid line number" >&2
                exit 1
                ;;
        esac
        if sed --version >/dev/null 2>&1; then
            # GNU sed
            sed -i "$1d" "$TODO_FILE"
        else
            # BSD sed
            sed -i "" "$1d" "$TODO_FILE"
        fi
        ;;
    next|n)
        head -1 "$TODO_FILE"
        ;;
    *)
        echo "invalid command: $cmd" >&2
        exit 1
        ;;
esac

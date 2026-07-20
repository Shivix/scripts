#!/usr/bin/env sh

set -eu

TODO_FILE="$HOME/.local/state/todo.txt"

cmd=${1:-}
if [ -n "$cmd" ]; then
    shift
fi

case "$cmd" in
    ""|inventory|i)
        cat "$TODO_FILE"
        ;;
    add|a|pickup)
        letter=$(awk '
            {
                sub(/\)$/, "", $1)
                used[$1] = 1
            }
            END {
                n = split("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z", letters, ",")
                for (i = 1; i <= n; i++) {
                    if (!(letters[i] in used)) {
                        print letters[i]
                        exit
                    }
                }
            }
        ' "$TODO_FILE")

        printf '%s) %s\n' "$letter" "$*" >>"$TODO_FILE"
        ;;
    edit|e|adjust)
        $EDITOR "$TODO_FILE"
        ;;
    remove|r|delete|d|drop)
        if [ $# -ne 1 ]; then
            echo "$cmd takes a single argument" >&2
            exit 1
        fi
        case "$1" in
            ''|*[!a-zA-Z])
                echo "invalid selection" >&2
                exit 1
                ;;
        esac
        if sed --version >/dev/null 2>&1; then
            # GNU sed
            INPLACE='-i'
        else
            # BSD sed
            INPLACE='-i ""'
        fi
        sed "$INPLACE" "/^$1) /d" "$TODO_FILE"
        ;;
    next|n)
        head -1 "$TODO_FILE"
        ;;
    read|whatis)
        grep "^$1) " "$TODO_FILE"
        ;;
    *)
        echo "invalid command: $cmd" >&2
        exit 1
        ;;
esac

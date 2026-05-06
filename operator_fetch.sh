#!/usr/bin/env bash

SEED="$USER"
HASH="$(printf "%s" "$SEED" | sha256sum | cut -c1-16)"
FINGERPRINT="$(printf '%s:%s:%s:%s' \
    "$(printf '%s' "$HASH" | cut -c1-4)" \
    "$(printf '%s' "$HASH" | cut -c5-8)" \
    "$(printf '%s' "$HASH" | cut -c9-12)" \
    "$(printf '%s' "$HASH" | cut -c13-16)")"

YELLOW="\033[33m"
RESET="\033[0m"

COLS=$(tput cols)
LINE=$(printf '═%.0s' $(seq 1 "$COLS"))

TEXT="OPERATOR IDENTIFIED"

PADDING=$(( (COLS - ${#TEXT}) / 2 ))
LEFT=$(printf '%*s' "$PADDING" '')
RIGHT=$(printf '%*s' "$((COLS - PADDING - ${#TEXT}))")

printf "${YELLOW}%s\n" "$LINE"
printf "%s%s%s\n" "$LEFT" "$TEXT" "$RIGHT"
printf "%s${RESET}\n" "$LINE"

USERTEXT="███████╗ ██╗  ██╗ ██╗ ██╗   ██╗ ██╗ ██╗  ██╗"
PADDING=$(( (COLS - ${#USERTEXT}) / 2 ))
LEFT=$(printf '%*s' "$PADDING" '')
printf "${YELLOW}"
printf "$LEFT███████╗ ██╗  ██╗ ██╗ ██╗   ██╗ ██╗ ██╗  ██╗\n"
printf "$LEFT██╔════╝ ██║  ██║ ██║ ██║   ██║ ██║ ╚██╗██╔╝\n"
printf "$LEFT███████╗ ███████║ ██║ ██║   ██║ ██║  ╚███╔╝\n"
printf "$LEFT╚════██║ ██╔══██║ ██║ ╚██╗ ██╔╝ ██║  ██╔██╗\n"
printf "$LEFT███████║ ██║  ██║ ██║  ╚████╔╝  ██║ ██╔╝ ██╗\n"
printf "$LEFT╚══════╝ ╚═╝  ╚═╝ ╚═╝   ╚═══╝   ╚═╝ ╚═╝  ╚═╝\n"
printf "${RESET}\n"

printf "${YELLOW}Status:         ${RESET}ONLINE\n"
printf "${YELLOW}Fingerprint:    ${RESET}%s\n" "$FINGERPRINT"
printf "${YELLOW}Terminal:       ${RESET}%s\n" "$(alacritty --version 2>/dev/null || echo "$TERM")"
printf "${YELLOW}Shell:          ${RESET}%s\n" "$($SHELL --version 2>/dev/null || echo "$SHELL")"
printf "${YELLOW}Editor:         ${RESET}%s\n" "${EDITOR:-unknown}"
if command -v dwm >/dev/null 2>&1; then
    printf "${YELLOW}Window Manager: ${RESET}%s\n" "$(dwm -v 2>&1)"
fi
if command -v xbps-query >/dev/null 2>&1; then
    printf "${YELLOW}Packages:       ${RESET}%s\n" "$(xbps-query -l | wc -l) (xbps)"
elif command -v pkg >/dev/null 2>&1; then
    printf "${YELLOW}Packages:  ${RESET}%s\n" "$(pkg info | wc -l) (pkg)"
fi
printf "\n"

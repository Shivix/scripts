#!/usr/bin/env bash

SEED="$USER"
HASH="$(printf "%s" "$SEED" | sha256sum | cut -c1-16)"
FINGERPRINT="${HASH:0:4}:${HASH:4:4}:${HASH:8:4}:${HASH:12:4}"

YELLOW="\033[33m"
BRYELLOW="\033[93m"
BRWHITE="\033[97m"
BOLD="\033[1m"
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
printf "${BRYELLOW}"
printf "$LEFT███████╗ ██╗  ██╗ ██╗ ██╗   ██╗ ██╗ ██╗  ██╗\n"
printf "$LEFT██╔════╝ ██║  ██║ ██║ ██║   ██║ ██║ ╚██╗██╔╝\n"
printf "$LEFT███████╗ ███████║ ██║ ██║   ██║ ██║  ╚███╔╝\n"
printf "$LEFT╚════██║ ██╔══██║ ██║ ╚██╗ ██╔╝ ██║  ██╔██╗\n"
printf "$LEFT███████║ ██║  ██║ ██║  ╚████╔╝  ██║ ██╔╝ ██╗\n"
printf "$LEFT╚══════╝ ╚═╝  ╚═╝ ╚═╝   ╚═══╝   ╚═╝ ╚═╝  ╚═╝\n"
printf "${RESET}\n"

printf "${BRYELLOW}${BOLD}Status:         ${RESET}${BRWHITE}ONLINE\n"
printf "${BRYELLOW}${BOLD}Fingerprint:    ${RESET}${BRWHITE}%s\n" "$FINGERPRINT"
printf "${BRYELLOW}${BOLD}Terminal:       ${RESET}${BRWHITE}%s\n" "$(alacritty --version)"
printf "${BRYELLOW}${BOLD}Shell:          ${RESET}${BRWHITE}%s\n" "$($SHELL --version)"
printf "${BRYELLOW}${BOLD}Window Manager: ${RESET}${BRWHITE}%s\n" "$(dwm -v 2>&1)"
printf "${BRYELLOW}${BOLD}Editor:         ${RESET}${BRWHITE}%s\n" "${EDITOR:-nvim}"

printf "${RESET}${YELLOW}${LINE}${RESET}\n"

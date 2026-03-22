#!/usr/bin/env bash

YELLOW="\033[33m"
BRYELLOW="\033[93m"
BRWHITE="\033[97m"
BOLD="\033[1m"
RESET="\033[0m"

COLS=$(tput cols)
LINE=$(printf '═%.0s' $(seq 1 "$COLS"))

TEXT="OPERATOR LOGIN SHELL"

PADDING=$(( (COLS - ${#TEXT}) / 2 ))
LEFT=$(printf '%*s' "$PADDING" '')
RIGHT=$(printf '%*s' "$((COLS - PADDING - ${#TEXT}))")

printf "${YELLOW}%s\n" "$LINE"
printf "%s%s%s\n" "$LEFT" "$TEXT" "$RIGHT"
printf "%s${RESET}\n" "$LINE"

printf "${BRYELLOW}${BOLD}OS:           ${RESET}${BRWHITE}%s\n" "$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
printf "${BRYELLOW}${BOLD}Kernel:       ${RESET}${BRWHITE}%s\n" "$(uname -sr)"
printf "${BRYELLOW}${BOLD}Host:         ${RESET}${BRWHITE}%s\n" "$(cat /sys/devices/virtual/dmi/id/product_version)"
printf "${BRYELLOW}${BOLD}CPU:          ${RESET}${BRWHITE}%s\n" "$(lscpu | grep 'Model name' | cut -d: -f2 | sed 's/^ *//')"
printf "${BRYELLOW}${BOLD}Memory:       ${RESET}${BRWHITE}%s\n" "$(free -h | awk '/Mem:/ {print $3 " / " $2}')"
printf "${BRYELLOW}${BOLD}Packages:     ${RESET}${BRWHITE}%s\n" "$(xbps-query -l | wc -l) (xbps)"
printf "${BRYELLOW}${BOLD}Disk (/):     ${RESET}${BRWHITE}%s\n" "$(df -h / | awk 'NR==2 {print $3" / "$2}')"
printf "${BRYELLOW}${BOLD}Disk (/var):  ${RESET}${BRWHITE}%s\n" "$(df -h /var | awk 'NR==2 {print $3" / "$2}')"
printf "${BRYELLOW}${BOLD}Disk (/home): ${RESET}${BRWHITE}%s\n" "$(df -h /home | awk 'NR==2 {print $3" / "$2}')"

printf "${RESET}${YELLOW}${LINE}${RESET}\n"

printf "${BRWHITE}${BOLD}Please enter operator credentials:${RESET}\n"

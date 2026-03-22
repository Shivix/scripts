#!/usr/bin/env bash

YELLOW="\033[33m"
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

printf "${YELLOW}OS:           ${RESET}%s\n" "$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')"
printf "${YELLOW}Kernel:       ${RESET}%s\n" "$(uname -sr)"
printf "${YELLOW}Host:         ${RESET}%s\n" "$(cat /sys/devices/virtual/dmi/id/product_version)"
printf "${YELLOW}CPU:          ${RESET}%s\n" "$(lscpu | grep 'Model name' | cut -d: -f2 | sed 's/^ *//')"
printf "${YELLOW}Memory:       ${RESET}%s\n" "$(free -h | awk '/Mem:/ {print $3 " / " $2}')"
printf "${YELLOW}Packages:     ${RESET}%s\n" "$(xbps-query -l | wc -l) (xbps)"
printf "${YELLOW}Tty:          ${RESET}%s\n" "$(tty)"
printf "${YELLOW}Disk (/):     ${RESET}%s\n" "$(df -h / | awk 'NR==2 {print $3" / "$2}')"
printf "${YELLOW}Disk (/var):  ${RESET}%s\n" "$(df -h /var | awk 'NR==2 {print $3" / "$2}')"
printf "${YELLOW}Disk (/home): ${RESET}%s\n" "$(df -h /home | awk 'NR==2 {print $3" / "$2}')"

printf "${RESET}${YELLOW}${LINE}${RESET}\n"

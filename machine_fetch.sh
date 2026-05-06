#!/usr/bin/env sh

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


if [ -f "/proc/uptime" ]; then
    printf "${YELLOW}Boot Time:       ${RESET}%s\n\n" "$(awk '{print int($1)"s"}' /proc/uptime)"
fi

printf "${YELLOW}Date:            ${RESET}%s\n" "$(date +'%A %d %b %Y')"
printf "${YELLOW}Time:            ${RESET}%s\n\n" "$(date +'%H:%M:%S')"

printf "${YELLOW}OS:              ${RESET}%s\n" "$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d \")"
if [ -f "/proc/cmdline" ]; then
    printf "${YELLOW}Kernel:          ${RESET}%s\n" "$(uname -sr)"
    printf "${YELLOW}Boot Parameters: ${RESET}%s\n" "$(awk '{print $1" "$2}' /proc/cmdline)"
fi
printf "${YELLOW}Init System:     ${RESET}%s\n\n" "$(ps -p 1 -o comm=)"

printf "${YELLOW}Architecture:    ${RESET}%s\n" "$(uname -m)"
if [ -f "/sys/class/power_supply/BAT0/capacity" ]; then
    printf "${YELLOW}Battery:         ${RESET}%s%%\n" "$(</sys/class/power_supply/BAT0/capacity)"
elif command -v sysctl >/dev/null 2>&1; then
    printf "${YELLOW}Battery:         ${RESET}%s%%\n" "$(sysctl -n hw.acpi.battery.life)"
fi

if [ -f "/proc/cpuinfo" ]; then
    # Make up for extra space in command output.
    printf "${YELLOW}CPU:             ${RESET}%s\n" "$(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2)"
else
    printf "${YELLOW}CPU:             ${RESET}%s\n" "$(sysctl -n hw.model)"
fi
printf "${YELLOW}Disk (/):        ${RESET}%s\n" "$(df -h / | awk 'NR==2 {print $3" / "$2}')"
printf "${YELLOW}Disk (/var):     ${RESET}%s\n" "$(df -h /var | awk 'NR==2 {print $3" / "$2}')"
printf "${YELLOW}Disk (/home):    ${RESET}%s\n" "$(df -h /home | awk 'NR==2 {print $3" / "$2}')"
printf "${YELLOW}Filesystem:      ${RESET}%s\n" "$(df -T / | awk 'NR==2 {print $2}')"
if [ -f "/sys/devices/virtual/dmi/id/product_version" ]; then
    printf "${YELLOW}Host:            ${RESET}%s\n" "$(</sys/devices/virtual/dmi/id/product_version)"
fi
if command -v free >/dev/null 2>&1; then
    printf "${YELLOW}RAM:             ${RESET}%s\n\n" "$(free -h | awk '/Mem:/ {print $3 " / " $2}')"
fi

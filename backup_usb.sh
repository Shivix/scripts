#!/usr/bin/env bash

set -euo pipefail

if command -v doas >/dev/null 2>&1; then
    SUDO=doas
else
    SUDO=sudo
fi

LABEL="storage"
MOUNT="/mnt/usb-backup"

DIRS=(
    "$HOME/.codex"
    "$HOME/.config"
    "$HOME/.gnupg"
    "$HOME/.local/share/fish"
    "$HOME/.local/share/newsboat"
    "$HOME/.local/share/zathura"
    "$HOME/.local/state/lus"
    "$HOME/.local/state/zua"
    "$HOME/.ssh"
    "$HOME/Documents"
    "$HOME/PersonalProjects/Lua"
    "$HOME/Pictures"
    "$HOME/System/bootstrap"
    "$HOME/System/configs"
    "$HOME/System/luasys"
    "$HOME/System/scripts"
)

DEVICE=$(blkid -L "$LABEL")

if [ -z "$DEVICE" ]; then
    echo "USB drive with label $LABEL not found"
    exit 1
fi

$SUDO mkdir -p "$MOUNT"

if ! mountpoint -q "$MOUNT"; then
    $SUDO mount "$DEVICE" "$MOUNT"
    $SUDO chown -R "$USER:$USER" "$MOUNT"
fi

DEST="$MOUNT/backup"

mkdir -p "$DEST"

for dir in "${DIRS[@]}"; do
    relative="${dir#$HOME/}"
    mkdir -p "$DEST/$relative"

    if [[ "$dir" == "$HOME/.config" ]]; then
        excludes=(
            --exclude "mozilla/"
            --exclude "pulse/"
            --exclude "mimeapps.list"
            --exclude "cni/"
            --exclude "go/"
        )
    else
        excludes=()
    fi

    rsync -aHAXv --delete --info=progress2 --delete-excluded "${excludes[@]}" "$dir/" "$DEST/$relative/"
done

sync
$SUDO umount "$MOUNT"
echo "Backup complete"

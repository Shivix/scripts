#!/usr/bin/env bash
set -euo pipefail

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
    "$HOME/System/ansible"
    "$HOME/System/configs"
    "$HOME/System/luasys"
    "$HOME/System/scripts"
)

DEVICE=$(blkid -L "$LABEL")

if [[ -z "$DEVICE" ]]; then
    echo "USB drive with label $LABEL not found"
    exit 1
fi

sudo mkdir -p "$MOUNT"

if ! mountpoint -q "$MOUNT"; then
    sudo mount "$DEVICE" "$MOUNT"
    sudo chown -R "$USER:$USER" "$MOUNT"
fi

DEST="$MOUNT/backup"

mkdir -p "$DEST"

for dir in "${DIRS[@]}"; do
    relative="${dir#$HOME/}"
    mkdir -p "$DEST/$relative"
    rsync -aHAX --delete --info=progress2 "$dir/" "$DEST/$relative/"
done

sync
sudo umount "$MOUNT"
echo "Backup complete"

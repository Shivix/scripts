#!/usr/bin/env sh

set -euo pipefail

if command -v doas >/dev/null 2>&1; then
    SUDO=doas
else
    SUDO=sudo
fi

LABEL="storage"
MOUNT="/mnt/usb"

DIRS="
.codex/
.config/
.gnupg/
.local/share/fish/
.local/share/zathura/
.local/state/lus/
.local/state/newsboat/
.local/state/zua/
.local/state/sh_history
.local/state/todo.txt
.ssh/
Documents/
PersonalProjects/Lua/
Pictures/
System/bootstrap/
System/configs/
System/luasys/
System/overlays/
System/scripts/
"

$SUDO mkdir -p "$MOUNT"

case "$(uname -s)" in
    FreeBSD)
        DEVICE="/dev/gpt/$LABEL"
        if [ ! -e "$DEVICE" ]; then
            echo "USB drive with label $LABEL not found" >&2
            exit 1
        fi
        if ! mount | grep -q "on /mnt/usb "; then
            $SUDO mount "$DEVICE" "$MOUNT"
        fi
        ;;
    Linux)
        DEVICE=$(blkid -L "$LABEL")
        if [ -z "$DEVICE" ]; then
            echo "USB drive with label $LABEL not found" >&2
            exit 1
        fi
        if ! mountpoint -q "$MOUNT"; then
            $SUDO mount "$DEVICE" "$MOUNT"
        fi
        ;;
    *)
        echo "Unsupported operating system" >&2
        exit 1
        ;;
esac

for relative in $DIRS; do
    SRC="$HOME/$relative"
    DEST="$MOUNT/backup/$relative"

    if [ ! -e "$SRC" ]; then
        continue
    fi

    if [ -d "$SRC" ]; then
        mkdir -p "$DEST"
    fi

    excludes=""
    if [ "$relative" = ".config/" ]; then
        excludes="--exclude mozilla/ --exclude pulse/ --exclude mimeapps.list --exclude cni/ --exclude go/"
    fi

    rsync -aHAXv --delete --info=progress2 --delete-excluded $excludes "$SRC" "$DEST"
done

sync
$SUDO umount "$MOUNT"
echo "Backup complete"

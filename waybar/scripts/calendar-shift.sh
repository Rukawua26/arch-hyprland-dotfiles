#!/bin/sh

state_file="${XDG_RUNTIME_DIR:-/tmp}/waybar-calendar-offset"
offset=0
[ -f "$state_file" ] && offset=$(cat "$state_file")

case "$offset" in
    ''|*[!0-9-]*) offset=0 ;;
esac

case "$1" in
    next) offset=$((offset + 1)) ;;
    prev) offset=$((offset - 1)) ;;
    reset) offset=0 ;;
esac

printf '%s\n' "$offset" > "$state_file"

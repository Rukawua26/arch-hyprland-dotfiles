#!/bin/sh

config="$HOME/.config/waybar/widgets.jsonc"
widget_pid=""

for pid in $(pgrep -x waybar); do
    cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline")
    case "$cmdline" in
        "waybar -c $config "*)
            widget_pid="$pid"
            break
            ;;
    esac
done

if [ -n "$widget_pid" ]; then
    kill "$widget_pid"
    exit 0
fi

waybar -c "$config" -s "$HOME/.config/waybar/widgets.css" \
    >/tmp/waybar-widgets.log 2>&1 &

#!/bin/sh

main_config="$HOME/.config/waybar/config.jsonc"
main_pid=""

for pid in $(pgrep -x waybar); do
    cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline")
    case "$cmdline" in
        "waybar -c $main_config "*)
            main_pid="$pid"
            break
            ;;
    esac
done

if [ -n "$main_pid" ]; then
    kill "$main_pid"
    exit 0
fi

waybar -c "$main_config" -s "$HOME/.config/waybar/style.css" \
    >/tmp/waybar-main.log 2>&1 &

#!/bin/sh

config="$HOME/.config/waybar/widgets.jsonc"
quick_config="$HOME/.config/waybar/quick-controls.jsonc"
buttons_config="$HOME/.config/waybar/quick-buttons.jsonc"
widget_pid=""
quick_pid=""
buttons_pid=""

for pid in $(pgrep -x waybar); do
    cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline")
    case "$cmdline" in
        "waybar -c $config "*)
            widget_pid="$pid"
            ;;
        "waybar -c $quick_config "*)
            quick_pid="$pid"
            ;;
        "waybar -c $buttons_config "*)
            buttons_pid="$pid"
            ;;
    esac
done

if [ -n "$widget_pid" ] || [ -n "$quick_pid" ] || [ -n "$buttons_pid" ]; then
    [ -n "$buttons_pid" ] && kill "$buttons_pid"
    [ -n "$quick_pid" ] && kill "$quick_pid"
    [ -n "$widget_pid" ] && kill "$widget_pid"
    exit 0
fi

waybar -c "$config" -s "$HOME/.config/waybar/widgets.css" \
    >/tmp/waybar-widgets.log 2>&1 &

waybar -c "$quick_config" -s "$HOME/.config/waybar/quick-controls.css" \
    >/tmp/waybar-quick-controls.log 2>&1 &

waybar -c "$buttons_config" -s "$HOME/.config/waybar/quick-buttons.css" \
    >/tmp/waybar-quick-buttons.log 2>&1 &

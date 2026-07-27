#!/bin/sh

selection=$(printf '1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n' | wofi --show dmenu --prompt 'Workspace')

case "$selection" in
    1|2|3|4|5|6|7|8|9|10) hyprctl dispatch workspace "$selection" >/dev/null ;;
esac

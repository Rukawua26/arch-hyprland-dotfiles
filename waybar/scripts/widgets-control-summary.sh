#!/bin/sh

volume="--"
if command -v wpctl >/dev/null 2>&1; then
    volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ printf "%d", $2 * 100 }')
elif command -v pactl >/dev/null 2>&1; then
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' 'NR==1 { gsub(/[% ]/, "", $2); print $2 }')
fi

brightness="--"
if command -v brightnessctl >/dev/null 2>&1; then
    brightness=$(brightnessctl -m | awk -F, '{ gsub(/%/, "", $4); print $4 }')
fi

battery="--"
for capacity in /sys/class/power_supply/BAT*/capacity; do
    [ -f "$capacity" ] || continue
    battery=$(cat "$capacity")
    break
done

text="<span foreground=\"#ff79c6\"> ${volume}%</span>    <span foreground=\"#f1fa8c\">󰃠 ${brightness}%</span>    <span foreground=\"#50fa7b\"> ${battery}%</span>"
tooltip="Volumen ${volume}%\nBrillo ${brightness}%\nBateria ${battery}%\nClick: mezclador de volumen"
jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

#!/bin/sh

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
prev_idle=$((idle + iowait))
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
sleep 0.15
read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
idle_all=$((idle + iowait))
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
diff_idle=$((idle_all - prev_idle))
diff_total=$((total - prev_total))
cpu=0
[ "$diff_total" -gt 0 ] && cpu=$((100 * (diff_total - diff_idle) / diff_total))

mem=$(free | awk '/Mem:/ { printf "%d", ($3 / $2) * 100 }')
temp_file=$(ls /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -n1)
temp="--"
[ -n "$temp_file" ] && temp=$(awk '{ printf "%d", $1 / 1000 }' "$temp_file")

text=" ${cpu}%     ${mem}%     ${temp}°C"
tooltip="CPU ${cpu}%\nMemoria ${mem}%\nTemperatura ${temp}°C"
jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

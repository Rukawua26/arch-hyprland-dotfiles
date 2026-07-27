#!/bin/sh

state_file="${XDG_RUNTIME_DIR:-/tmp}/waybar-calendar-offset"
offset=0
[ -f "$state_file" ] && offset=$(cat "$state_file")

case "$offset" in
    ''|*[!0-9-]*) offset=0 ;;
esac

month=$(date -d "$(date +%Y-%m-01) $offset months" +%m)
year=$(date -d "$(date +%Y-%m-01) $offset months" +%Y)
label=$(date -d "$(date +%Y-%m-01) $offset months" +'%B %Y')
calendar=$(cal -m "$month" "$year")
text=$(printf '‹  %s  ›\n%s' "$label" "$calendar")

jq -cn --arg text "$text" --arg tooltip "Click izquierdo: siguiente mes | click derecho: mes anterior | click central: mes actual" '{text: $text, tooltip: $tooltip}'

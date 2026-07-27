#!/bin/sh

active=$(hyprctl activeworkspace -j | jq -r '.id')
text=""

for workspace in $(seq 1 10); do
    if [ "$workspace" = "$active" ]; then
        case "$workspace" in
            1) symbol="❶" ;; 2) symbol="❷" ;; 3) symbol="❸" ;; 4) symbol="❹" ;; 5) symbol="❺" ;;
            6) symbol="❻" ;; 7) symbol="❼" ;; 8) symbol="❽" ;; 9) symbol="❾" ;; 10) symbol="❿" ;;
        esac
        item="<span foreground=\"#d8b4fe\" font_weight=\"bold\">$symbol</span>"
    else
        case "$workspace" in
            1) symbol="①" ;; 2) symbol="②" ;; 3) symbol="③" ;; 4) symbol="④" ;; 5) symbol="⑤" ;;
            6) symbol="⑥" ;; 7) symbol="⑦" ;; 8) symbol="⑧" ;; 9) symbol="⑨" ;; 10) symbol="⑩" ;;
        esac
        item="<span foreground=\"#9d91b5\">$symbol</span>"
    fi
    text="$text$item "
done

jq -cn --arg text "$text" --arg tooltip "Click: elegir workspace | Scroll: cambiar workspace" '{text: $text, tooltip: $tooltip}'

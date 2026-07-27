#!/bin/sh

wifi="󰤭"
wifi_tip="Wi-Fi sin conexion"

if command -v nmcli >/dev/null 2>&1; then
    active=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi list 2>/dev/null | awk -F: '$1 == "yes" { print $2 ":" $3; exit }')
    if [ -n "$active" ]; then
        ssid=${active%:*}
        signal=${active##*:}
        wifi="󰤨 ${signal}%"
        wifi_tip="Wi-Fi: ${ssid} (${signal}%)"
    fi
fi

bt=""
bt_tip="Bluetooth"
if command -v bluetoothctl >/dev/null 2>&1; then
    powered=$(bluetoothctl show 2>/dev/null | sed -n 's/^\s*Powered: //p' | head -n1)
    connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)
    if [ "$powered" != "yes" ]; then
        bt="󰂲"
        bt_tip="Bluetooth apagado"
    elif [ "$connected" -gt 0 ]; then
        bt="󰂱 ${connected}"
        bt_tip="Bluetooth conectado (${connected})"
    else
        bt_tip="Bluetooth encendido"
    fi
fi

mic=""
mic_tip="Dictado apagado"
if pgrep -f "[n]erd-dictation begin" >/dev/null 2>&1; then
    mic=""
    mic_tip="Dictado activo"
fi

text="<span foreground=\"#8be9fd\">⬡ 󰤨 WiFi</span>   <span foreground=\"#bd93f9\">⬡ $bt BT</span>   <span foreground=\"#f1fa8c\">⬡ $mic Mic</span>"
tooltip="$wifi_tip\n$bt_tip\n$mic_tip\nClick: activar microfono | Click derecho: Wi-Fi | Click medio: Bluetooth"
jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

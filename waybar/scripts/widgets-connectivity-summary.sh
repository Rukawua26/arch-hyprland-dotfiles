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

text="<span foreground=\"#8be9fd\">$wifi</span>    <span foreground=\"#bd93f9\">$bt</span>"
tooltip="$wifi_tip\n$bt_tip\nClick: Wi-Fi | Click derecho: Bluetooth"
jq -cn --arg text "$text" --arg tooltip "$tooltip" '{text: $text, tooltip: $tooltip}'

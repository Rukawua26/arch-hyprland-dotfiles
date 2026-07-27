#!/usr/bin/env bash

set -euo pipefail

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config.rasi"

notify() {
    notify-send "Bluetooth" "$1"
}

json_escape() {
    local value
    value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    printf '%s' "$value"
}

controller_show() {
    bluetoothctl show 2>/dev/null || true
}

powered_state() {
    controller_show | sed -n 's/^\s*Powered: //p' | head -n1
}

discovering_state() {
    controller_show | sed -n 's/^\s*Discovering: //p' | head -n1
}

device_connected() {
    bluetoothctl info "$1" 2>/dev/null | sed -n 's/^\s*Connected: //p' | head -n1
}

device_paired() {
    bluetoothctl info "$1" 2>/dev/null | sed -n 's/^\s*Paired: //p' | head -n1
}

device_trusted() {
    bluetoothctl info "$1" 2>/dev/null | sed -n 's/^\s*Trusted: //p' | head -n1
}

list_devices() {
    bluetoothctl devices 2>/dev/null || true
}

list_connected() {
    bluetoothctl devices Connected 2>/dev/null || true
}

toggle_power() {
    if [[ "$(powered_state)" == "yes" ]]; then
        bluetoothctl power off >/dev/null
        notify "Apagado"
    else
        rfkill unblock bluetooth >/dev/null 2>&1 || true
        bluetoothctl power on >/dev/null
        bluetoothctl agent on >/dev/null 2>&1 || true
        bluetoothctl default-agent >/dev/null 2>&1 || true
        notify "Encendido"
    fi
}

scan_and_reopen() {
    rfkill unblock bluetooth >/dev/null 2>&1 || true
    bluetoothctl power on >/dev/null 2>&1 || true
    bluetoothctl agent on >/dev/null 2>&1 || true
    bluetoothctl default-agent >/dev/null 2>&1 || true
    notify "Escaneando dispositivos durante 8 segundos"
    bluetoothctl --timeout 8 scan on >/dev/null 2>&1 || true
    "$0" menu
}

status_json() {
    local powered discovering connected tooltip names count icon class text
    powered="$(powered_state)"
    discovering="$(discovering_state)"
    connected="$(list_connected)"
    count=0
    names=""

    if [[ -n "$connected" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            count=$((count + 1))
            names+="${line#Device $(awk '{print $2}' <<< "$line") }\\n"
        done <<< "$connected"
    fi

    if [[ "$powered" != "yes" ]]; then
        icon="󰂲"
        class="disabled"
        tooltip="Bluetooth apagado"
    elif (( count > 0 )); then
        icon="󰂱"
        class="connected"
        tooltip="Conectados (${count})\\n${names%\\n}"
    elif [[ "$discovering" == "yes" ]]; then
        icon="󰂯"
        class="scanning"
        tooltip="Bluetooth encendido\\nEscaneando dispositivos"
    else
        icon=""
        class="enabled"
        tooltip="Bluetooth encendido\\nSin dispositivos conectados"
    fi

    text="$icon"
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$(json_escape "$text")" "$(json_escape "$tooltip")" "$(json_escape "$class")"
}

menu() {
    local powered selection label mac name connected paired trusted line choices action
    local -a rofi_cmd
    powered="$(powered_state)"
    rofi_cmd=(rofi -dmenu -i -p "Bluetooth")

    if [[ -f "$ROFI_THEME" ]]; then
        rofi_cmd+=( -theme "$ROFI_THEME" )
    fi

    if [[ -z "$(controller_show)" ]]; then
        notify "No se encontro un controlador Bluetooth"
        exit 1
    fi

    choices=""
    if [[ "$powered" == "yes" ]]; then
        choices+="Apagar Bluetooth\n"
        choices+="Escanear dispositivos\n"
    else
        choices+="Encender Bluetooth\n"
    fi

    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        mac=$(awk '{print $2}' <<< "$line")
        name=${line#Device $mac }
        connected="$(device_connected "$mac")"
        paired="$(device_paired "$mac")"
        trusted="$(device_trusted "$mac")"

        if [[ "$connected" == "yes" ]]; then
            label="Desconectar: $name [$mac]"
        elif [[ "$paired" == "yes" || "$trusted" == "yes" ]]; then
            label="Conectar: $name [$mac]"
        else
            label="Emparejar y conectar: $name [$mac]"
        fi

        choices+="$label\n"
    done <<< "$(list_devices)"

    selection=$(printf '%b' "$choices" | sed '/^$/d' | "${rofi_cmd[@]}")
    [[ -z "$selection" ]] && exit 0

    case "$selection" in
        "Encender Bluetooth"|"Apagar Bluetooth")
            toggle_power
            ;;
        "Escanear dispositivos")
            scan_and_reopen
            ;;
        *)
            action=${selection%%:*}
            mac=${selection##*[}
            mac=${mac%]}
            name=${selection#*: }
            name=${name% [$mac]}

            if [[ -z "$mac" ]]; then
                notify "No pude resolver el dispositivo seleccionado"
                exit 1
            fi

            case "$action" in
                "Conectar")
                    bluetoothctl connect "$mac" >/dev/null && notify "Conectado a $name"
                    ;;
                "Desconectar")
                    bluetoothctl disconnect "$mac" >/dev/null && notify "Desconectado de $name"
                    ;;
                "Emparejar y conectar")
                    rfkill unblock bluetooth >/dev/null 2>&1 || true
                    bluetoothctl power on >/dev/null 2>&1 || true
                    bluetoothctl agent on >/dev/null 2>&1 || true
                    bluetoothctl default-agent >/dev/null 2>&1 || true
                    bluetoothctl pair "$mac" >/dev/null && bluetoothctl trust "$mac" >/dev/null && bluetoothctl connect "$mac" >/dev/null
                    notify "Emparejado y conectado a $name"
                    ;;
            esac
            ;;
    esac
}

case "${1:-status}" in
    status)
        status_json
        ;;
    menu)
        menu
        ;;
    power)
        toggle_power
        ;;
    scan)
        scan_and_reopen
        ;;
esac

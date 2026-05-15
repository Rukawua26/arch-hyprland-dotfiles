#!/usr/bin/env bash

set -euo pipefail

ROFI_THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config.rasi"
export LC_ALL=C

notify() {
    notify-send "Wi-Fi" "$1"
}

json_escape() {
    local value
    value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    printf '%s' "$value"
}

rofi_menu() {
    local -a rofi_cmd
    rofi_cmd=(rofi -dmenu -i -p "$1")

    if [[ -f "$ROFI_THEME" ]]; then
        rofi_cmd+=( -theme "$ROFI_THEME" )
    fi

    "${rofi_cmd[@]}"
}

wifi_enabled() {
    [[ "$(nmcli radio wifi)" == "enabled" ]]
}

active_wifi() {
    nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi list | awk -F: '$1 == "yes" { print $2 ":" $3; exit }'
}

signal_icon() {
    local signal=${1:-0}
    if (( signal >= 80 )); then
        printf '󰤨'
    elif (( signal >= 60 )); then
        printf '󰤥'
    elif (( signal >= 40 )); then
        printf '󰤢'
    elif (( signal >= 20 )); then
        printf '󰤟'
    else
        printf '󰤯'
    fi
}

scan_wifi() {
    nmcli device wifi rescan >/dev/null 2>&1 || true
}

toggle_wifi() {
    if wifi_enabled; then
        nmcli radio wifi off
        notify "Wi-Fi apagado"
    else
        nmcli radio wifi on
        scan_wifi
        notify "Wi-Fi encendido"
    fi
}

known_connection() {
    local ssid=$1
    nmcli -t -f NAME connection show | awk -v target="$ssid" '$0 == target { found=1 } END { exit found ? 0 : 1 }'
}

connect_wifi() {
    local ssid=$1
    local security=$2
    local password

    nmcli radio wifi on >/dev/null 2>&1 || true

    if [[ -z "$security" || "$security" == "--" ]]; then
        nmcli device wifi connect "$ssid" >/dev/null && notify "Conectado a $ssid"
        return
    fi

    if known_connection "$ssid"; then
        nmcli connection up "$ssid" >/dev/null 2>&1 || nmcli device wifi connect "$ssid" >/dev/null 2>&1
        notify "Conectado a $ssid"
        return
    fi

    password=$(printf '' | rofi_menu "Clave de $ssid")
    [[ -z "$password" ]] && exit 0

    nmcli device wifi connect "$ssid" password "$password" >/dev/null && notify "Conectado a $ssid"
}

connect_hidden_wifi() {
    local ssid password security

    ssid=$(printf '' | rofi_menu "SSID oculta")
    [[ -z "$ssid" ]] && exit 0

    security=$(printf 'WPA/WPA2\nAbierta\n' | rofi_menu "Seguridad de $ssid")
    [[ -z "$security" ]] && exit 0

    nmcli radio wifi on >/dev/null 2>&1 || true

    if [[ "$security" == "Abierta" ]]; then
        nmcli device wifi connect "$ssid" hidden yes >/dev/null && notify "Conectado a $ssid"
        return
    fi

    password=$(printf '' | rofi_menu "Clave de $ssid")
    [[ -z "$password" ]] && exit 0

    nmcli device wifi connect "$ssid" password "$password" hidden yes >/dev/null && notify "Conectado a $ssid"
}

status_json() {
    local active ssid signal icon tooltip class text networks_count

    if ! wifi_enabled; then
        printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$(json_escape "󰖪")" "$(json_escape "Wi-Fi apagado")" "disabled"
        return
    fi

    active=$(active_wifi)
    networks_count=$(nmcli -t -f SSID dev wifi list | awk 'NF { count++ } END { print count + 0 }')

    if [[ -n "$active" ]]; then
        ssid=${active%%:*}
        signal=${active##*:}
        icon=$(signal_icon "$signal")
        tooltip="$ssid\nSenal: ${signal}%\nRedes visibles: ${networks_count}"
        class="connected"
        text="$icon"
    else
        icon="󰤭"
        tooltip="Sin conexion\nRedes visibles: ${networks_count}"
        class="disconnected"
        text="$icon"
    fi

    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$(json_escape "$text")" "$(json_escape "$tooltip")" "$(json_escape "$class")"
}

menu() {
    local selection line active ssid signal security bars prefix label payload
    local choices=""

    if wifi_enabled; then
        choices+="Apagar Wi-Fi\n"
        choices+="Escanear redes\n"
        choices+="Conectar a red oculta\n"
    else
        choices+="Encender Wi-Fi\n"
    fi

    if wifi_enabled; then
        scan_wifi

        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            IFS=: read -r active ssid signal security <<< "$line"
            [[ -z "$ssid" ]] && ssid="<oculta>"
            bars=$(signal_icon "${signal:-0}")

            if [[ "$active" == "yes" ]]; then
                prefix="Desconectar"
            else
                prefix="Conectar"
            fi

            label="$prefix: $ssid ${bars} ${signal:-0}%"
            if [[ -n "$security" && "$security" != "--" ]]; then
                label+=" ${security}"
            fi

            payload="$prefix|$ssid|${security:---}"
            choices+="$label [$payload]\n"
        done <<< "$(nmcli -t -f ACTIVE,SSID,SIGNAL,SECURITY dev wifi list | awk -F: '!seen[$2]++')"
    fi

    selection=$(printf '%b' "$choices" | sed '/^$/d' | rofi_menu "Wi-Fi")
    [[ -z "$selection" ]] && exit 0

    case "$selection" in
        "Encender Wi-Fi")
            nmcli radio wifi on
            scan_wifi
            notify "Wi-Fi encendido"
            ;;
        "Apagar Wi-Fi")
            nmcli radio wifi off
            notify "Wi-Fi apagado"
            ;;
        "Escanear redes")
            scan_wifi
            "$0" menu
            ;;
        "Conectar a red oculta")
            connect_hidden_wifi
            ;;
        *)
            payload=${selection##*[}
            payload=${payload%]}
            IFS='|' read -r action ssid security <<< "$payload"

            if [[ "$ssid" == "<oculta>" ]]; then
                notify "Las redes ocultas no se manejan desde este menu"
                exit 0
            fi

            if [[ "$action" == "Desconectar" ]]; then
                nmcli connection down "$ssid" >/dev/null 2>&1 || nmcli device disconnect wlp0s20f3 >/dev/null 2>&1
                notify "Desconectado de $ssid"
            else
                connect_wifi "$ssid" "$security"
            fi
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
    toggle)
        toggle_wifi
        ;;
    scan)
        scan_wifi
        ;;
esac

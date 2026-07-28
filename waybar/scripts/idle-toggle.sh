#!/usr/bin/env bash

set -euo pipefail

ICON_ACTIVE=""
ICON_INACTIVE=""

get_status() {
    if pgrep -x hypridle > /dev/null; then
        printf '{"text": "%s", "class": "inactive", "alt": "idle-on", "tooltip": "Idle activo — Pantalla se apagará"}' "$ICON_INACTIVE"
    else
        printf '{"text": "%s", "class": "active", "alt": "idle-off", "tooltip": "Idle desactivado — Pantalla siempre encendida"}' "$ICON_ACTIVE"
    fi
}

toggle() {
    if pgrep -x hypridle > /dev/null; then
        pkill -x hypridle
    else
        hypridle &
    fi
}

case "${1:-}" in
    toggle) toggle ;;
    *)      get_status ;;
esac

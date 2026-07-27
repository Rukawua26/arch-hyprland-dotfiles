#!/usr/bin/env bash
#
# battery-alert.sh — Monitor de batería con alertas escalonadas
#
# Niveles de alerta (solo cuando la batería está descargándose):
#   20%  → notify-send normal (dismissable)
#   15%  → notify-send critical (dismissable)
#   10%  → notify-send critical con re-envío cada 10s si se cierra
#
# La notificación del 10% usa el hint x-canonical-private-synchronous
# para reemplazar la anterior en lugar de acumular notificaciones.
#
# Al conectar el cargador: se cancelan todas las alertas pendientes.
#
# Uso: ~/.config/waybar/scripts/battery-alert.sh &
#   o: exec-once = ~/.config/waybar/scripts/battery-alert.sh

set -euo pipefail

BATTERY_PATH="/org/freedesktop/UPower/devices/battery_BAT0"
POLL_INTERVAL=30
CRITICAL_RESEND_INTERVAL=10
NOTIF_ID="battery-critical"

# Estado entre iteraciones
notified_20=false
notified_15=false
last_critical_notify=0

log() {
    echo "[$(date '+%H:%M:%S')] $*" >&2
}

get_battery_info() {
    local info
    info=$(upower -i "$BATTERY_PATH" 2>/dev/null) || return 1

    local state percent
    state=$(echo "$info" | grep -oP 'state:\s+\K\w+')
    percent=$(echo "$info" | grep -oP 'percentage:\s+\K\d+')

    echo "${state:-unknown} ${percent:-0}"
}

send_notification() {
    local urgency="$1"
    local summary="$2"
    local body="$3"
    local icon="${4:-}"

    notify-send \
        -u "$urgency" \
        -t 0 \
        -h "string:x-canonical-private-synchronous:${NOTIF_ID}" \
        ${icon:+-i "$icon"} \
        "$summary" \
        "$body"
}

main() {
    log "Iniciando monitor de batería..."

    while true; do
        local info state percent
        info=$(get_battery_info) || {
            log "Error leyendo batería, reintentando en ${POLL_INTERVAL}s"
            sleep "$POLL_INTERVAL"
            continue
        }

        read -r state percent <<< "$info"

        # Si está cargando → resetear todo
        if [[ "$state" == "charging" || "$state" == "fully-charged" ]]; then
            if $notified_20 || $notified_15; then
                log "Cargador conectado. Reseteando alertas."
            fi
            notified_20=false
            notified_15=false
            last_critical_notify=0
            sleep "$POLL_INTERVAL"
            continue
        fi

        # Solo actuar si está descargándose
        if [[ "$state" != "discharging" ]]; then
            sleep "$POLL_INTERVAL"
            continue
        fi

        # --- Lógica de alertas ---

        # 20%
        if (( percent <= 20 )) && ! $notified_20; then
            log "Alerta 20%: batería al ${percent}%"
            send_notification \
                "normal" \
                "🔋 Batería baja" \
                "Queda ${percent}% de batería. Conecta el cargador pronto." \
                "power-low"
            notified_20=true
        fi

        # 15%
        if (( percent <= 15 )) && ! $notified_15; then
            log "Alerta 15%: batería al ${percent}%"
            send_notification \
                "normal" \
                "⚡ Batería muy baja" \
                "Solo queda ${percent}% de batería. ¡Conecta el cargador ya!" \
                "power-critical"
            notified_15=true
        fi

        # 10% — re-envío persistente
        if (( percent <= 10 )); then
            local now elapsed
            now=$(date +%s)
            elapsed=$(( now - last_critical_notify ))

            if (( elapsed >= CRITICAL_RESEND_INTERVAL )); then
                log "Alerta 10% (persistente): batería al ${percent}%"
                send_notification \
                    "critical" \
                    "🚨 BATERÍA CRÍTICA" \
                    "¡Solo ${percent}%! Conecta el cargador INMEDIATAMENTE." \
                    "power-battery"
                last_critical_notify=$now
            fi
        fi

        sleep "$POLL_INTERVAL"
    done
}

main "$@"

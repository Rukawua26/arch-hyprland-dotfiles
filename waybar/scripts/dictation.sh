#!/bin/sh

export PATH=/usr/bin:/bin

is_running() {
    pgrep -f "[n]erd-dictation begin" >/dev/null 2>&1
}

start_dictation() {
    if ! is_running; then
        nohup nerd-dictation begin --simulate-input-tool=WTYPE --numbers-as-digits --full-sentence --timeout=2.5 --delay-exit=0.4 >/tmp/nerd-dictation.log 2>&1 &
    fi
}

stop_dictation() {
    nerd-dictation end >/dev/null 2>&1 || true
}

case "$1" in
    toggle)
        if is_running; then
            stop_dictation
        else
            start_dictation
        fi
        ;;
    stop|cancel)
        stop_dictation
        ;;
    status|*)
        if is_running; then
            printf '{"text":"","tooltip":"Dictado activo - click para detener","class":"active"}\n'
        else
            printf '{"text":"","tooltip":"Dictado apagado - click para iniciar","class":"inactive"}\n'
        fi
        ;;
esac

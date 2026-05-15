#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Restaurando configuraciones..."

for dir in "$REPO_DIR"/config/*/; do
    app="$(basename "$dir")"
    target="$HOME/.config/$app"
    mkdir -p "$target"
    cp -r "$dir"/* "$target/"
    echo "  → $app restaurado"
done

if [ -f "$REPO_DIR/config/mimeapps.list" ]; then
    cp "$REPO_DIR/config/mimeapps.list" "$HOME/.config/mimeapps.list"
    echo "  → mimeapps.list restaurado"
fi

if [ -f "$REPO_DIR/.bashrc" ]; then
    cp "$REPO_DIR/.bashrc" "$HOME/.bashrc"
    echo "  → .bashrc restaurado"
fi

if [ -f "$REPO_DIR/.npmrc" ]; then
    cp "$REPO_DIR/.npmrc" "$HOME/.npmrc"
    echo "  → .npmrc restaurado"
fi

mkdir -p "$HOME/.local/bin"
if [ -d "$REPO_DIR/scripts" ] && [ "$(ls -A "$REPO_DIR/scripts")" ]; then
    cp "$REPO_DIR/scripts"/* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin"/*
    echo "  → scripts restaurados"
fi

echo ""
echo "Configuracion restaurada correctamente."
echo "Reinicia sesion o recarga las apps para aplicar cambios."

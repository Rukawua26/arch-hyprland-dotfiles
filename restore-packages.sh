#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$REPO_DIR/packages"

echo "=== Restaurando paquetes ==="

if [ ! -f "$PKG_DIR/pacman.txt" ]; then
    echo "Error: no se encuentra packages/pacman.txt"
    exit 1
fi

echo ""
echo "1/3 - Instalando paquetes oficiales (pacman)..."
sudo pacman -S --needed --noconfirm - < "$PKG_DIR/pacman.txt"

if [ -f "$PKG_DIR/aur.txt" ] && [ -s "$PKG_DIR/aur.txt" ]; then
    echo ""
    echo "2/3 - Instalando paquetes AUR (yay)..."
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm - < "$PKG_DIR/aur.txt"
    elif command -v paru &>/dev/null; then
        paru -S --needed --noconfirm - < "$PKG_DIR/aur.txt"
    else
        echo "  Instala yay o paru primero y ejecuta:"
        echo "  yay -S --needed - < $PKG_DIR/aur.txt"
    fi
fi

if [ -f "$PKG_DIR/flatpak.txt" ] && [ -s "$PKG_DIR/flatpak.txt" ]; then
    echo ""
    echo "3/3 - Instalando aplicaciones Flatpak..."
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        flatpak install --noninteractive flathub "$app" 2>/dev/null || true
    done < "$PKG_DIR/flatpak.txt"
fi

if [ -f "$PKG_DIR/systemd-services.txt" ] && [ -s "$PKG_DIR/systemd-services.txt" ]; then
    echo ""
    echo "Habilitando servicios systemd --user..."
    while IFS= read -r service; do
        [ -z "$service" ] && continue
        systemctl --user enable --now "$service" 2>/dev/null || true
    done < "$PKG_DIR/systemd-services.txt"
fi

echo ""
echo "Paquetes restaurados correctamente."

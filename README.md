# Arch Hyprland Dotfiles

Configuracion personal de Arch Linux con Hyprland, Fish, Waybar y mas.

## Restaurar despues de formatear

```bash
# 1. Clonar el repo
git clone https://github.com/miguel/arch-hyprland-dotfiles
cd arch-hyprland-dotfiles

# 2. Restaurar paquetes (pacman + AUR + flatpak)
./restore-packages.sh

# 3. Restaurar configuraciones
./install.sh

# 4. (Opcional) Habilitar servicios
systemctl --user enable --now cliphist
systemctl --user enable --now dunst
```

## Que incluye

| App | Config |
|-----|--------|
| Hyprland | hyprland.conf, hypridle, hyprlock, hyprpaper |
| Waybar | barra, modulos, estilos |
| Fish | config.fish, funciones, completions |
| Kitty | terminal |
| Ghostty | terminal |
| Dunst | notificaciones |
| Rofi | lanzador |
| Wofi | menu |
| Swaync | centro de notificaciones |
| Wlogout | menu de sesion |
| Fastfetch | info del sistema |
| Btop | monitor del sistema |
| Cava | visualizador de audio |
| GTK / Qt | temas y apariencia |
| PipeWire / WirePlumber | audio |
| Zellij | multiplexor de terminal |
| Starship | prompt |

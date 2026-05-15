<p align="center">
  <img src="https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Hyprland-00B4D8?style=for-the-badge&logo=hyprland&logoColor=white" />
  <img src="https://img.shields.io/badge/Wayland-FFBC00?style=for-the-badge&logo=wayland&logoColor=black" />
  <img src="https://img.shields.io/badge/Fish-34C534?style=for-the-badge&logo=fish-shell&logoColor=white" />
  <br/>
  <img src="https://img.shields.io/badge/status-active-success?style=flat-square" />
  <img src="https://img.shields.io/github/last-commit/Rukawua26/arch-hyprland-dotfiles?style=flat-square" />
  <img src="https://img.shields.io/github/repo-size/Rukawua26/arch-hyprland-dotfiles?style=flat-square" />
</p>

<h1 align="center">⚡ Arch Hyprland Dotfiles ⚡</h1>

<p align="center">
  <b>Configuración personal de Arch Linux + Hyprland</b><br/>
  Waybar · Fish · Kitty/Ghostty · Dunst · Rofi · Wofi · Swaync · Wlogout · Fastfetch · Btop · Cava · Zellij · Starship
</p>

---

## 📸 Vista previa

<p align="center">
  <i>(Agrega aquí una captura de pantalla de tu escritorio)</i>
  <br/>
  <code>~/.config/hypr/hyprland.conf</code> · Waybar con módulos personalizados · Kitty con temas Tokyo Night
</p>

---

## 🚀 Restauración rápida

Después de instalar Arch Linux base, ejecuta estos comandos:

```bash
# Paquetes esenciales si no los tienes
sudo pacman -S --needed git yay flatpak

# Clonar el repositorio
git clone https://github.com/Rukawua26/arch-hyprland-dotfiles
cd arch-hyprland-dotfiles

# Instalar TODOS los paquetes (pacman + AUR + flatpak → 131 oficiales + 5 AUR + 15 flatpak)
./restore-packages.sh

# Copiar configuraciones a ~/.config/
./install.sh

# ¡Reinicia sesión y listo!
```

---

## ✨ Features

| Componente | App | Detalle |
|:-----------|:----|:--------|
| 🪟 **Window Manager** | Hyprland | `hyprland.conf`, `hypridle`, `hyprlock`, `hyprpaper` |
| 📊 **Status Bar** | Waybar | Módulos: red, bluetooth, volumen, clima, sistema |
| 🐚 **Shell** | Fish | `config.fish`, funciones FZF, autocompletados |
| 🖥️ **Terminal** | Kitty / Ghostty | Temas Tokyo Night, atajos optimizados |
| 🔔 **Notificaciones** | Dunst | Notificaciones emergentes estilizadas |
| 🔍 **Launcher** | Rofi / Wofi | Tema synthwave, lanzador de apps |
| 📋 **Centro de notificaciones** | Swaync | Panel lateral de notificaciones |
| 🔌 **Gestor de sesión** | Wlogout | Menú de apagado/suspensión/reinicio |
| ℹ️ **System Info** | Fastfetch | Logo personalizado, info del sistema |
| 📈 **Monitor** | Btop | Tema Tokyo Night, CPU/RAM/disco |
| 🎵 **Visualizador** | Cava | Visualización de audio en terminal |
| 🎨 **Temas GTK/Qt** | GTK3/4, Kvantum, Qt5ct/Qt6ct | Tema Wallbash synthwave |
| 🔊 **Audio** | PipeWire + WirePlumber | Perfil de audio optimizado, sin suspender |
| 📦 **Terminal multiplexer** | Zellij | Layouts predefinidos para desarrollo |
| ✨ **Prompt** | Starship | Prompt rápido e informativo |

---

## 🗺️ Estructura del repositorio

```
dotfiles/
├── config/                    # ~/.config/ de cada aplicación
│   ├── hypr/                  # Hyprland (WM, idle, lock, paper)
│   ├── waybar/                # Barra + scripts (red, bluetooth)
│   ├── fish/                  # Shell (funciones, FZF)
│   ├── kitty/                 # Terminal emulator
│   ├── ghostty/               # Terminal emulator (GPU)
│   ├── dunst/                 # Notificaciones
│   ├── rofi/                  # App launcher
│   ├── wofi/                  # App launcher (alternativo)
│   ├── swaync/                # Centro de notificaciones
│   ├── wlogout/               # Menú de sesión + iconos
│   ├── fastfetch/             # System info + logos
│   ├── btop/                  # Monitor de sistema + temas
│   ├── cava/                  # Visualizador de audio
│   ├── gtk-3.0/               # Tema GTK3
│   ├── qt5ct/ qt6ct/          # Tema Qt5/Qt6
│   ├── pipewire/              # PipeWire config
│   ├── wireplumber/           # WirePlumber config
│   ├── zellij/                # Terminal multiplexer
│   ├── systemd/               # Servicios de usuario
│   └── mimeapps.list          # Aplicaciones por defecto
├── scripts/                   # Scripts personalizados
│   ├── hyprwhspr-toggle
│   └── lmstudio
├── packages/                  # Listas de paquetes para reinstalar
│   ├── pacman.txt             # 131 paquetes oficiales
│   ├── aur.txt                # 5 paquetes AUR
│   ├── flatpak.txt            # 15 aplicaciones Flatpak
│   └── systemd-services.txt   # Servicios systemd --user
├── install.sh                 # Script de instalación de configs
├── restore-packages.sh        # Script de restauración de paquetes
└── README.md                  # Este archivo
```

---

## 📦 Paquetes incluidos

### Arch Linux (131 oficiales)

`hyprland` · `waybar` · `fish` · `kitty` · `ghostty` · `dunst` · `rofi` · `wofi` · `swaync` · `wlogout` · `fastfetch` · `btop` · `cava` · `starship` · `zellij` · `pipewire` · `wireplumber` · `dolphin` · `firefox` · `brave-bin` · `code` · `neovim` · `git` · `github-cli` · `fzf` · `eza` · `btop` · `cliphist` · `grim` · `slurp` · `hyprshot` · `hyprlock` · `hypridle` · `hyprpaper` · `hyprpicker` · `ufw` · `blueman` · `brightnessctl` · `pavucontrol` · `pamixer` · `playerctl` · `nwg-look` · `qt5ct` · `qt6ct` · `kvantum` · `uwsm` · `ydotool` · `gdm` · `yay-bin` · `opencode-bin` · `mise` · `obs-studio` · `python-numpy` · `python-requests` · `python-rich` · `rustdesk-bin` · `zoom` · `zram-generator`

### AUR (5)
`antigravity-bin` · `awww` · `hyprwhspr` · `hyprquery-git` · `satty`

### Flatpak (15)
`GIMP` · `Inkscape` · `Krita` · `Blender` · `OBS Studio` · `Mission Center` · `Flatseal` · `Warehouse` · `Impression` · `Upscaler` · `Clapper` · `VideoDownloader` · `WebCord` · `GNOME Boxes` · `Eye of GNOME`

---

## 🧭 Servicios systemd --user habilitados

| Servicio | Descripción |
|:---------|:------------|
| `cliphist` | Clipboard manager |
| `dunst` | Notificaciones |
| `pipewire` + `wireplumber` | Audio |
| `hyprwhspr` | Hypr workspace indicators |
| `sniper-ai` | Sniper AI Watchdog |
| `xdg-desktop-portal-hyprland` | Portal de escritorio |
| `gcr-ssh-agent` | SSH agent |

---

## 🛠️ Scripts personalizados

| Script | Descripción |
|:-------|:------------|
| `hyprwhspr-toggle` | Alterna visibilidad de workspaces |
| `lmstudio` | Lanzador de LM Studio CLI |
| `waybar/scripts/network.sh` | Monitor de red para Waybar |
| `waybar/scripts/bluetooth.sh` | Estado de Bluetooth para Waybar |

---

## 📝 Notas post-instalación

- **GDM** como gestor de sesión (con Hyprland en uwsm)
- **UFW** configurado para firewall básico
- **ZRAM** con `zram-generator` para compresión de memoria
- Repositorio **Chaotic-AUR** añadido para paquetes como `hyprwhspr`
- Sesión de Hyprland gestionada con **UWSM**

---

<p align="center">
  <b>Hecho con ❤️ para Arch Linux</b><br/>
  <sub>Miguel · 2026</sub>
</p>

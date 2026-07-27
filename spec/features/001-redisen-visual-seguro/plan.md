# Plan tecnico

## Enfoque

Aplicar un tema azul/purpura explicito y conservador sobre la configuracion activa. Se preservara la estructura funcional y solo se cambiaran valores visuales. Waybar se tratara como contrato: sus modulos, formatos, iconos y scripts no se editan.

## Archivos a tocar

- `hypr/hyprland.conf`: agregar variables de tema y sustituir solo colores visuales equivalentes.
- `waybar/style.css`: redisenar fondo, tarjetas, estados y tooltip sin tocar nombres de modulos.
- `hypr/hyprlock.conf`: armonizar colores y textos visuales sin cambiar autenticacion.
- `wofi/style.css`: armonizar colores sin cambiar estructura de entradas.
- `waybar/widgets.jsonc`: panel flotante derecho con los módulos secundarios existentes.
- `waybar/widgets.css`: tarjetas verticales del panel flotante.
- `waybar/scripts/toggle-widgets.sh`: alternar la instancia secundaria de Waybar.
- No hay configuracion versionada de Rofi o Wlogout en esta fuente activa; quedan fuera de esta iteracion.

## Archivos protegidos

- `waybar/modules.json`: solo se añade la acción del reloj; formatos e iconos quedan protegidos.
- `waybar/scripts/*`
- `hypr/hypridle.conf`
- `hypr/hyprpaper.conf`
- keybindings, autostart, variables de entorno y reglas funcionales no visuales

## Orden

1. Registrar y comparar modulos/iconos de Waybar.
2. Crear variables de tema en Hyprland y mantener blur actual.
3. Aplicar estilo Waybar preservando todos sus selectores funcionales.
4. Separar visualmente la barra superior y el panel flotante sin duplicar procesos al alternarlo.
5. Armonizar Hyprlock, Wofi, Rofi y Wlogout.
6. Validar sintaxis, diff y recarga.

## Verificacion

- `jq` para validar JSON estricto cuando aplique.
- Comparacion de listas de modulos antes y despues.
- Busqueda de formatos e iconos antes y despues.
- `hyprctl reload` y lectura de opciones activas.
- `git diff --check`.
- Revision visual manual posterior por parte del usuario.

## Verificacion contra alucinaciones

- Confirmar que cada archivo listado existe antes de editarlo.
- No inventar modulos ni rutas de iconos.
- Confirmar que los nombres de variables y bloques existen en los archivos actuales.
- Comparar el diff con los criterios de aceptacion.
- No revertir ni modificar cambios preexistentes fuera del alcance.

## Limite de iteraciones

Maximo 3 iteraciones por tarea. Si `hyprctl reload` falla, se revierte solo el cambio de la tarea y se documenta la causa.

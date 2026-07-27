# Redisen visual seguro de Hyprland

## Objetivo

Unificar el aspecto visual activo de Hyprland, Waybar, Hyprlock y Wofi usando los acentos azul y purpura existentes, sin perder modulos, iconos, atajos, scripts ni servicios.

## Alcance

- Mejorar la jerarquia visual de Waybar sin cambiar sus modulos ni formatos.
- Hacer editables los colores principales de Hyprland desde una seccion de tema.
- Mantener el blur amplio ya activo y evitar aumentarlo sin evidencia de rendimiento.
- Armonizar colores y estados de Hyprlock y Wofi.
- Mantener una Waybar superior minimalista y abrir un panel flotante derecho bajo demanda con los módulos secundarios existentes.
- Verificar sintaxis y recarga antes de considerar el cambio terminado.

## Fuera de alcance

- No eliminar módulos ni cambiar sus iconos, formatos, comandos o scripts; se permite cambiar la distribución visual de `waybar/config.jsonc` y añadir el click del reloj en `waybar/modules.json`.
- No eliminar ni cambiar iconos, scripts, comandos, keybindings o servicios.
- No instalar paquetes ni cambiar configuracion del sistema.
- No sobrescribir cambios preexistentes del repositorio.
- No activar automaticamente esta copia sobre otra fuente de configuracion.

## Fuente de verdad

- Configuracion activa: `/home/miguel/dev/config/dotfiles`.
- Sesion activa: `hyprctl` confirma blur habilitado.
- Modulos e iconos de Waybar: `waybar/config.jsonc` y `waybar/modules.json`.
- Cambios preexistentes: estado Git capturado antes de editar.

## Criterios de aceptacion

1. Los 16 modulos declarados en `waybar/config.jsonc` permanecen identicos.
2. `waybar/modules.json` no cambia.
3. Los formatos e iconos definidos en `modules.json` permanecen identicos.
4. Los keybindings, programas, variables de entorno y servicios de Hyprland permanecen funcionalmente intactos.
5. `hyprctl reload` termina sin error despues de aplicar el archivo de Hyprland.
6. Blur amplio se mantiene habilitado sin aumentar `size` ni `passes`.
7. Los colores principales pueden cambiarse editando una seccion de tema claramente marcada.
8. Los archivos CSS y de tema siguen siendo validos para sus aplicaciones.
9. El rollback queda documentado por archivo y no usa `git restore` sobre archivos con cambios preexistentes.
10. La barra superior conserva logo, workspaces y reloj; el panel secundario se abre/cierra sin duplicar la barra principal.
11. El panel flotante reutiliza los módulos y scripts existentes y se posiciona a la derecha en layer overlay.

## Riesgos

- El blur ya consume GPU; no se incrementara durante esta iteracion.
- Cambiar CSS puede afectar legibilidad; se verificara contraste visual y estados criticos.
- Hay modificaciones preexistentes en el repositorio; solo se editaran lineas dentro del alcance.

## Preguntas abiertas

- La activacion desde la fuente activa queda pendiente de la validacion visual del usuario.

#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Obtener la lista de keymaps disponibles y formatearla adecuadamente
keymaps=$(localectl list-keymaps | awk '{print NR, $0}')

# Verificar si se pudo obtener la lista de keymaps
if [ $? -ne 0 ]; then
  mostrar_error "Error al obtener la lista de keymaps."
fi

# Mostrar un menú de selección de keymap
keymap_seleccionado=$(whiptail --menu "Seleccione su keymap:" 20 60 10 \
  ${keymaps} \
  3>&1 1>&2 2>&3)

# Verificar si el usuario seleccionó un keymap
if [ $? -ne 0 ]; then
  mostrar_error "No se seleccionó ningún keymap."
fi

# Extraer el keymap seleccionado
keymap_seleccionado=$(echo "$keymaps" | sed -n "${keymap_seleccionado}p" | awk '{print $2}')

# Configurar el keymap seleccionado
localectl set-keymap "$keymap_seleccionado"

# Mostrar un mensaje de confirmación
whiptail --msgbox "El keymap se ha configurado como $keymap_seleccionado." 10 50

# Continuar con otros pasos de configuración o instalación si es necesario

# Finalizar el script
exit 0


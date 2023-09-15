#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Obtener la lista de keymaps disponibles
keymaps=$(find /usr/share/kbd/keymaps -type f -name "*.map.gz" | sed 's|.*/||')

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

# Configurar el keymap seleccionado
loadkeys "$keymap_seleccionado"

# Mostrar un mensaje de confirmación
whiptail --msgbox "El keymap se ha configurado como $keymap_seleccionado." 10 40

# Continuar con la instalación de Arch Linux
# Agregue aquí los pasos adicionales que desee realizar

# Ejemplo: Instalar Arch Linux utilizando pacstrap y chroot
# pacstrap /mnt base base-devel
# ...

# Finalizar el script
exit 0

#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Obtener la lista de zonas horarias disponibles
zonas_horarias=$(zoneinfo list)

# Verificar si se pudo obtener la lista de zonas horarias
if [ $? -ne 0 ]; then
  mostrar_error "Error al obtener la lista de zonas horarias."
fi

# Mostrar un menú de selección de zona horaria
zona_seleccionada=$(whiptail --menu "Seleccione su zona horaria:" 20 60 10 \
  ${zonas_horarias} \
  3>&1 1>&2 2>&3)

# Verificar si el usuario seleccionó una zona horaria
if [ $? -ne 0 ]; then
  mostrar_error "No se seleccionó ninguna zona horaria."
fi

# Configurar la zona horaria seleccionada
timedatectl set-timezone "$zona_seleccionada"

# Mostrar un mensaje de confirmación
whiptail --msgbox "La zona horaria se ha configurado como $zona_seleccionada." 10 40

# Continuar con la instalación de Arch Linux
# Agregue aquí los pasos adicionales que desee realizar

# Ejemplo: Instalar Arch Linux utilizando pacstrap y chroot
# pacstrap /mnt base base-devel
# ...

# Finalizar el script
exit 0

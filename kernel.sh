#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Utilizar Whiptail para mostrar un menú de selección de kernel
opcion=$(whiptail --menu "Seleccione el kernel que desea instalar:" 15 50 5 \
  "linux-zen" "Kernel Zen para un mejor rendimiento" \
  "linux" "Kernel Linux" \
  "linux-lts" "Kernel de soporte a largo plazo" 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Selección de kernel cancelada."
fi

# Almacenar la selección del kernel en una variable
kernel_seleccionado="$opcion"

# Mostrar un mensaje de confirmación
whiptail --msgbox "El kernel $kernel_seleccionado se ha seleccionado." 10 50

# Continuar con otros pasos de configuración o instalación si es necesario

# Finalizar el script
exit 0

#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Obtener la lista de locales disponibles
locales_disponibles=$(cat /etc/locale.gen | grep -v '^#' | awk '{print $1}')

# Verificar si se pudo obtener la lista de locales
if [ $? -ne 0 ]; then
  mostrar_error "Error al obtener la lista de locales."
fi

# Mostrar un menú de selección de locales
locale_seleccionado=$(whiptail --menu "Seleccione su locale:" 20 60 10 \
  ${locales_disponibles} \
  3>&1 1>&2 2>&3)

# Verificar si el usuario seleccionó un locale
if [ $? -ne 0 ]; then
  mostrar_error "No se seleccionó ningún locale."
fi

# Descomentar la línea correspondiente en /etc/locale.gen
sed -i "s/^# ${locale_seleccionado}/${locale_seleccionado}/" /etc/locale.gen

# Generar los locales seleccionados
locale-gen

# Configurar el locale seleccionado
echo "LANG=${locale_seleccionado}" > /etc/locale.conf

# Mostrar un mensaje de confirmación
whiptail --msgbox "El locale se ha configurado como $locale_seleccionado." 10 40

# Continuar con la instalación de Arch Linux
# Agregue aquí los pasos adicionales que desee realizar

# Ejemplo: Instalar Arch Linux utilizando pacstrap y chroot
# pacstrap /mnt base base-devel
# ...

# Finalizar el script
exit 0

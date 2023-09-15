#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Descomentar las líneas que comienzan con '#letra'
sed -i '/^#[a-z][a-z]/s/^#//' /etc/locale.gen

# Obtener las locales disponibles únicas
locales_disponibles=$(grep '^[a-z][a-z]' /etc/locale.gen | sort -u)

# Verificar si no se encontraron locales disponibles
if [ -z "$locales_disponibles" ]; then
  mostrar_error "No se encontraron locales disponibles en /etc/locale.gen."
fi

# Formatear las locales disponibles para una sola columna
locales_formateadas=""
for locale in ${locales_disponibles}; do
  locales_formateadas="${locales_formateadas} ${locale} -"
done

# Mostrar un menú de selección de locales en una sola columna
locale_seleccionada=$(whiptail --menu "Seleccione su locale:" 20 60 10 \
  ${locales_formateadas} \
  3>&1 1>&2 2>&3)

# Verificar si el usuario seleccionó una locale
if [ $? -ne 0 ]; then
  mostrar_error "No se seleccionó ninguna locale."
fi

# Configurar la locale seleccionada
locale_seleccionada=$(echo "$locales_formateadas" | awk '{print $1}' | sed -n "${locale_seleccionada}p")
localectl set-locale LANG="$locale_seleccionada"

# Mostrar un mensaje de confirmación
whiptail --msgbox "La locale se ha configurado como $locale_seleccionada." 10 50

# Generar las locales seleccionadas
locale-gen

# Continuar con otros pasos de configuración o instalación si es necesario

# Finalizar el script
exit 0


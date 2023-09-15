#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Detectar si el sistema está en modo UEFI o BIOS
if [ -d "/sys/firmware/efi" ]; then
  # El sistema está en modo UEFI
  modo="UEFI"
  carpeta_boot="/boot/efi"
else
  # El sistema está en modo BIOS
  modo="BIOS"
  carpeta_boot="/boot"
fi

# Utilizar 'lsblk' para listar los discos disponibles
discos=$(lsblk -d -n -o NAME)

# Crear un arreglo de opciones para que el usuario elija el disco
opciones=()
for disco in $discos; do
  opciones+=("$disco" "")
done

# Solicitar al usuario que elija el disco
disco_seleccionado=$(whiptail --menu "Seleccione el disco en el que desea crear particiones:" 20 60 10 "${opciones[@]}" 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Selección de disco cancelada."
fi

# Construir el dispositivo completo en función de la selección del usuario
dispositivo="/dev/$disco_seleccionado"

# Solicitar al usuario que ingrese el tamaño de la partición raíz
tamanio_raiz=$(whiptail --inputbox "Tamaño de la partición raíz (en GB):" 10 60 50 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Creación de partición raíz cancelada."
fi

# Crear la partición raíz (tamaño personalizado)
parted -s "$dispositivo" mkpart primary ext4 0% "$tamanio_raiz"GB

# Formatear la partición raíz como ext4
mkfs.ext4 "${dispositivo}1"

# Montar la partición raíz en un directorio (por ejemplo, /mnt)
mount "${dispositivo}1" /mnt

# Crear la carpeta /boot o /boot/efi según el modo (BIOS o UEFI)
mkdir -p /mnt$carpeta_boot

# Solicitar al usuario que ingrese el tamaño de la partición de intercambio (swap)
tamanio_swap=$(whiptail --inputbox "Tamaño de la partición de intercambio (swap) (en GB):" 10 60 4 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Creación de partición de intercambio (swap) cancelada."
fi

# Crear la partición de intercambio (swap) (tamaño personalizado)
dd if=/dev/zero of="${dispositivo}2" bs=1M count="$((tamanio_swap * 1024))"

# Formatear la partición de intercambio como swap
mkswap "${dispositivo}2"

# Activar la partición de intercambio
swapon "${dispositivo}2"

# Mostrar un mensaje de confirmación
whiptail --msgbox "Partición raíz y partición de intercambio (swap) creadas, formateadas y montadas con éxito en el dispositivo $dispositivo (Modo $modo)." 10 70

# Continuar con otros pasos de configuración o instalación si es necesario

# Finalizar el script
exit 0

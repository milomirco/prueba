#!/bin/bash

# Función para mostrar un mensaje de error y salir
function mostrar_error() {
  whiptail --msgbox "$1" 10 40
  exit 1
}

# Solicitar el nombre de usuario
usuario=$(whiptail --inputbox "Ingrese el nombre de usuario:" 10 40 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Creación de usuario cancelada."
fi

# Crear el usuario con el nombre proporcionado
useradd -m "$usuario"

# Verificar si la creación de usuario fue exitosa
if [ $? -ne 0 ]; then
  mostrar_error "Error al crear el usuario."
fi

# Agregar el usuario al grupo "wheel"
usermod -aG wheel "$usuario"

# Verificar si la adición al grupo fue exitosa
if [ $? -ne 0 ]; then
  mostrar_error "Error al agregar el usuario al grupo wheel."
fi

# Solicitar la contraseña del usuario
contrasena_usuario=$(whiptail --passwordbox "Ingrese la contraseña para el usuario $usuario:" 10 40 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Creación de usuario cancelada."
fi

# Establecer la contraseña del usuario
echo "$usuario:$contrasena_usuario" | chpasswd

# Solicitar la contraseña de root
contrasena_root=$(whiptail --passwordbox "Ingrese la contraseña para el usuario root:" 10 40 3>&1 1>&2 2>&3)

# Verificar si el usuario canceló la operación
if [ $? -ne 0 ]; then
  mostrar_error "Creación de usuario cancelada."
fi

# Establecer la contraseña de root
echo "root:$contrasena_root" | chpasswd

# Mostrar un mensaje de confirmación
whiptail --msgbox "Usuario $usuario creado y configurado con éxito." 10 40

# Continuar con el script principal o la instalación de Arch Linux
# Agregue aquí los pasos adicionales que desee realizar

# Finalizar el script
exit 0

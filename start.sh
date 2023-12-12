#!/bin/bash

# Función para imprimir errores
print_error() {
    echo -e "\e[97;41mError:\e[0m \e[97;41m$1\e[0m"
}

clear

# Pedir Nombre de Cliente
read -p "Ingrese nombre del cliente: " cliente
export cliente
echo ""

# Pedir Nombre de Usuario
read -p "Ingrese nombre de usuario: " username
export username
echo ""

# Pedir Contraseña
while true; do
    read -s -p "Ingrese la contraseña para el servidor: " password
    echo

# Pedir Confirmación de Contraseña
    read -s -p "Confirme la contraseña: " confirm_password
    echo

# Verificar si la contraseña y la confirmación coinciden
    if [ "$password" = "$confirm_password" ]; then
        break  # Salir del bucle si las contraseñas coinciden
    else
        echo -e "\e[97;41mERROR: Las contraseñas no coinciden. Inténtelo nuevamente\e[0m"
    fi
done
export password
echo ""

# Preguntar si descargar imágenes
read -p "¿Descargar imágenes de Docker? (y/n): " download_images
clear

# Cambiar Hostname
echo "Actualizando Hostname"
hostnamectl set-hostname "$cliente" > /dev/null 2>&1 || print_error "No se pudo cambiar el hostname"

# Instalar Dependencias
echo ""
echo "Instalando Dependencias:"
apt-get update -y > /dev/null 2>&1 || print_error "No se pudieron actualizar las dependencias"
apt-get upgrade -y > /dev/null 2>&1 || print_error "No se pudieron actualizar las dependencias"
apt-get install iptables -y > /dev/null 2>&1 || print_error "No se pudieron instalar iptables"
apt-get install curl -y > /dev/null 2>&1 || print_error "No se pudo instalar curl"
apt-get install git -y > /dev/null 2>&1 || print_error "No se pudo instalar git"
curl -s https://install.zerotier.com | sudo bash > /dev/null 2>&1 || print_error "No se pudo instalar Zero-Tier"
export PATH=/usr/sbin:$PATH

# Iniciar Zero-Tier y Unirse a la red (Clientes)
echo ""
echo "Añadiendo servidor a la red de Clientes:"
service zerotier-one start > /dev/null 2>&1 || print_error "No se pudo iniciar Zero-Tier"
zerotier-cli join 9f77fc393ec5b201 > /dev/null 2>&1 || print_error "No se pudo unir a la red Zero-Tier"

# Instalar Docker
echo ""
echo "Instalando Docker:"
if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1 || print_error "No se pudo descargar Docker"
  sudo sh get-docker.sh > /dev/null 2>&1 || print_error "No se pudo instalar Docker"
fi

# Copiar la carpeta Portainer pre configurada al servidor
echo ""
echo "Copiando carpetas pre configuradas:"
chmod -R 777 /home/$username > /dev/null 2>&1 || print_error "No se pudo cambiar permisos de la carpeta"
git clone https://github.com/$username/Cliente-Domotica.git /tmp/docker > /dev/null 2>&1 || print_error "No se pudo clonar el repositorio"
mv /tmp/docker/docker /home/$username/docker > /dev/null 2>&1 || print_error "No se pudo mover la carpeta docker"
rm -r /tmp/docker > /dev/null 2>&1 || print_error "No se pudo borrar el repositorio temporal"

# Actualizar Nombre de Cliente y Contraseñas
echo ""
echo "Actualizando Archivos Docker Compose:"
if wget -q https://raw.githubusercontent.com/$username/Cliente-Domotica/main/replace.sh && chmod +x replace.sh; then
    ./replace.sh
else
    print_error "No se pudo Atcualizar Archivos Docker Compose"
fi

# Descargar imágenes solo si se selecciona "y" (sí)
if [ "$download_images" == "y" ]; then
    # Descargar imágenes
    echo ""
    echo "Descargando Imágenes de Docker:"
    if ! { wget https://raw.githubusercontent.com/$username/Cliente-Domotica/main/descargar_imagenes.sh && chmod +x descargar_imagenes.sh; } > /dev/null 2>&1; then
      print_error "No se pudieron descargar las imágenes o instalar Portainer"
    fi
    ./descargar_imagenes.sh
fi

# Agregar $username a sudoers y dar permiso para usar docker
echo ""
echo "Actualizando Permisos de usuario:"
echo "$username ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$username > /dev/null 2>&1 || print_error "No se pudo agregar a $username a sudoers"
sudo usermod -aG docker $username > /dev/null 2>&1 || print_error "No se pudo dar permisos de docker a $username"

# Instalar Portainer
echo ""
echo "Instalando Portainer:"
docker run -dt -p 9000:9000 --name=Portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/$username/docker/portainer:/data portainer/portainer:latest || print_error "No se pudo ejecutar el contenedor de Portainer"

# Obtener la dirección del coordinador Zigbee y remplazarla en el docker compose
echo ""
echo "Detectando Coordinador y añadiéndolo al docker compose:"
if ! { wget https://raw.githubusercontent.com/$username/Cliente-Domotica/main/agregar_coordinador.sh && chmod +x agregar_coordinador.sh; } > /dev/null 2>&1; then
  print_error "No se pudo descargar el script agregar_coordinador.sh"
fi
./agregar_coordinador.sh

echo ""
echo "Limpiando archivos de instalación:"
rm -r *.sh

echo ""
echo "No te olvides de aceptar el permiso de join en Zero-Tier"
echo ""
echo "Portainer está listo para el deploy de docker compose"
echo ""
echo ""
echo ""
echo "REINICIANDO!!!"
reboot

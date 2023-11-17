#!/bin/bash

# Función para imprimir errores
print_error() {
    echo "Error: $1"
}

clear

# Instalar Dependencias
echo "Instalado Dependencias"
echo ""
apt-get update -y > /dev/null 2>&1 || print_error "No se pudieron actualizar las dependencias"
apt-get upgrade -y > /dev/null 2>&1 || print_error "No se pudieron actualizar las dependencias"
apt-get install iptables -y > /dev/null 2>&1 || print_error "No se pudieron instalar iptables"
apt-get install curl -y > /dev/null 2>&1 || print_error "No se pudo instalar curl"
apt-get install git -y > /dev/null 2>&1 || print_error "No se pudo instalar git"
curl -s https://install.zerotier.com | sudo bash > /dev/null 2>&1 || print_error "No se pudo instalar Zero-Tier"
export PATH=/usr/sbin:$PATH

# Iniciar Zero-Tier y Unirse a la red (Clientes)
echo "Añadiendo servidor a la red de Clientes"
echo ""
service zerotier-one start > /dev/null 2>&1 || print_error "No se pudo iniciar Zero-Tier"
zerotier-cli join 9f77fc393ec5b201 > /dev/null 2>&1 || print_error "No se pudo unir a la red Zero-Tier"

# Instalar Docker
echo "Instalando Docker"
echo ""
if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1 || print_error "No se pudo descargar Docker"
  sudo sh get-docker.sh > /dev/null 2>&1 || print_error "No se pudo instalar Docker"
fi

# Agregar djcrawleravp a sudoers y dar permiso para usar docker
echo "Actualizando Permisos de usuario"
echo ""
echo "djcrawleravp ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/djcrawleravp > /dev/null 2>&1 || print_error "No se pudo agregar a djcrawleravp a sudoers"
sudo usermod -aG docker djcrawleravp > /dev/null 2>&1 || print_error "No se pudo dar permisos de docker a djcrawleravp"

# Copiar la carpeta Portainer pre configurada al servidor
echo "Copiando carpetas pre configuradas"
echo ""
chmod -R 777 /home/djcrawleravp > /dev/null 2>&1 || print_error "No se pudo cambiar permisos de la carpeta"
git clone https://github.com/djcrawleravp/Cliente-Domotica.git /tmp/docker > /dev/null 2>&1 || print_error "No se pudo clonar el repositorio"
mv /tmp/docker/docker /home/djcrawleravp/docker > /dev/null 2>&1 || print_error "No se pudo mover la carpeta docker"
rm -r /tmp/docker > /dev/null 2>&1 || print_error "No se pudo borrar el repositorio temporal"

# Descargar imágenes e Instalar Portainer
echo "Descargando Imagenes de Docker"
echo ""
wget https://raw.githubusercontent.com/djcrawleravp/Cliente-Domotica/main/descargar_imagenes.sh > /dev/null 2>&1 || print_error "No se pudieron descargar las imágenes o instalar Portainer"
chmod +x descargar_imagenes.sh > /dev/null 2>&1 || print_error "No se pudieron descargar las imágenes o instalar Portainer"
./descargar_imagenes.sh > /dev/null 2>&1 || print_error "No se pudieron descargar las imágenes o instalar Portainer"
echo "Instalando Portainer"
echo ""
docker run -dt -p 9000:9000 --name=Portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/djcrawleravp/docker/portainer:/data portainer/portainer:latest > /dev/null 2>&1 || print_error "No se pudo ejecutar el contenedor de Portainer"

# Obtener la dirección del coordinador Zigbee y remplazarla en el docker compose
echo "Detectando Coordinador y añadiendolo al docker compose"
echo ""
wget https://raw.githubusercontent.com/djcrawleravp/Cliente-Domotica/main/agregar_coordinador.sh > /dev/null 2>&1 || print_error "No se pudo ejecutar agregar_coordinador.sh"
chmod +x agregar_coordinador.sh > /dev/null 2>&1 || print_error "No se pudo ejecutar agregar_coordinador.sh"
./agregar_coordinador.sh 

echo ""
echo "No te olvides de aceptar el permiso de join en Zero-Tier"
echo ""
echo "Portainer está listo para el deploy de docker compose"
echo ""
echo ""
echo ""

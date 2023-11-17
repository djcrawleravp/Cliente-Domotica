#!/bin/bash

# Agrega djcrawleravp a sudoers
echo "djcrawleravp ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/djcrawleravp

# Instalar Dependencias
apt-get update && apt-get upgrade -y
apt-get install iptables -y
apt-get install curl -y
apt-get install git -y 
curl -s https://install.zerotier.com | sudo bash
export PATH=/usr/sbin:$PATH

#Iniciar Zero-Tier y Unirse a la red (Clientes)
service zerotier-one start
zerotier-cli join 9f77fc393ec5b201

# Instalar Docker usando curl
if ! [ -x "$(command -v docker)" ]; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
fi

# Copia la carpeta Portainer pre configurada al servidor

chmod -R 777 /home/djcrawleravp
git clone https://github.com/djcrawleravp/Cliente-Domotica.git /tmp/docker
mv /tmp/docker/docker /home/djcrawleravp/docker
rm -r /tmp/docker

# Descarga imagenes e Instala Portainer
./descargar_imagenes.sh
docker run -dt -p 9000:9000 --name=Portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/djcrawleravp/docker/portainer:/data portainer/portainer:latest

# Limpiar pantalla y Obtener la dirección del coordinador Zigbee
./agregar_coordinador.sh

echo ""
echo "Aceptar el permiso de join en Zero-Tier"
echo ""
echo "Continuar con el deployment en Portainer"

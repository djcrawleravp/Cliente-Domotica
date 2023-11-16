#!/bin/bash

# Solicitar la contraseña
read -p "Ingresa la contraseña para el usuario djcrawleravp: " -s contrasena
echo

# Verifica si el usuario ya existe
if id "djcrawleravp" &>/dev/null; then
    echo "El usuario djcrawleravp ya existe. No se realizaron cambios."
    exit 1
fi

# Crea el usuario y lo agrega a sudoers
useradd -m -s /bin/bash djcrawleravp
echo "djcrawleravp:$contrasena" | chpasswd
echo "djcrawleravp ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/djcrawleravp

# Instalar Dependencias
apt-get update && apt-get upgrade -y
apt-get install iptables -y
apt-get install curl -y
wget https://download.zerotier.com/dist/zerotier-one_debian_stretch_amd64.deb
dpkg -i zerotier-one_debian_stretch_amd64.deb

#Iniciar Zero-Tier y Unirse a la red (Clientes)
service zerotier-one start
zerotier-cli join 9f77fc393ec5b201

# Instalar Docker usando curl
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instala Portainer
docker run -dt -p 9000:9000 --name=Portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /home/djcrawleravp/docker/portainer:/data portainer/portainer:latest

echo "Continuar con el paso 2 en Portainer"

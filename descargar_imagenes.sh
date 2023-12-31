#!/bin/bash

# Descargar Imágenes Docker
images=(
  "ghcr.io/home-assistant/home-assistant:stable"
  "eclipse-mosquitto:latest"
  "koenkk/zigbee2mqtt:latest"
  "nodered/node-red:latest"
  "rhasspy/wyoming-whisper:latest"
  "containrrr/watchtower:latest"
  "louislam/uptime-kuma:1"
  "amir20/dozzle:latest"
  "dperson/samba:latest"
  "ghcr.io/linuxserver/duplicati:latest"
  "containrrr/watchtower:latest"
  "portainer/portainer:latest"
)

for image in "${images[@]}"; do
  if ! docker pull "$image" > /dev/null 2>&1; then
    echo -e "\e[97;41mError al descargar la imagen: $image\e[0m"
  else
    echo -e "\e[40;32m$image Descargado\e[0m"
  fi
done

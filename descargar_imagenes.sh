#!/bin/bash

# Descargar Imágenes Docker
images=(
  #"ghcr.io/home-assistant/home-assistant:stable"
  #"eclipse-mosquitto:latest"
  #"koenkk/zigbee2mqtt:latest"
  #"nodered/node-red:latest"
  #"rhasspy/wyoming-whisper:latest"
  #"containrrr/watchtower:latest"
  "portainer/portainer:latest"
)

for image in "${images[@]}"; do
  if ! docker pull "$image" > /dev/null 2>&1; then
    echo -e "\e[31;40mError al descargar la imagen: $image\e[0m"
    echo ""
  else
    echo -e "\e[32;40m$image Descargado\e[0m"

    echo ""
  fi
done

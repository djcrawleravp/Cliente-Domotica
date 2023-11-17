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
    echo "Error al descargar la imagen: $image"
  else
    echo "$image Descargado"
  fi
done

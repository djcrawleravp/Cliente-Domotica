#!/bin/bash

#Descargar Imagenes Docker
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
  docker pull "$image"
done

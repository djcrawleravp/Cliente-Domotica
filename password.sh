#!/bin/bash

docker_compose_file="/home/djcrawleravp/docker/portainer/custom_templates/2/docker-compose.yml"

if [ -n "$password" ]; then
    # Utilizamos sed para buscar y reemplazar la etiqueta "#Contraseña" con la contraseña
    sed -i "s|#Contraseña|$password|g" "$docker_compose_file"
else
    echo -e "\e[97;41mERROR: No se proporcionó una contraseña válida\e[0m"
fi
if [ -n "$cliente" ]; then
    # Utilizamos sed para buscar y reemplazar la etiqueta "#Cliente" con el nombre
    sed -i "s|#Cliente|$cliente|g" "$docker_compose_file"
else
    echo -e "\e[97;41mERROR: No se proporcionó un nombre válido\e[0m"
fi
if [ -n "$username" ]; then
    sed -i "s|#username|$username|g" "$docker_compose_file"
else
    echo -e "\e[97;41mERROR: No se proporcionó un nombre de usuario válido\e[0m"
fi

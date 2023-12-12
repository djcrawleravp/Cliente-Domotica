#!/bin/bash

# Rutas de Docker Compose
docker_compose_file_1="/home/$username/docker/portainer/custom_templates/1/docker-compose.yml"
docker_compose_file_2="/home/$username/docker/portainer/custom_templates/2/docker-compose.yml"

# Función para reemplazar etiquetas en un archivo docker-compose.yml
replace_labels() {
    local file="$1"
    if [ -n "$password" ]; then
        sed -i "s|#Contraseña|$password|g" "$file"
    else
        echo -e "\e[97;41mERROR: No se proporcionó una contraseña válida\e[0m"
    fi

    if [ -n "$cliente" ]; then
        sed -i "s|#Cliente|$cliente|g" "$file"
    else
        echo -e "\e[97;41mERROR: No se proporcionó un nombre válido\e[0m"
    }

    if [ -n "$username" ]; then
        sed -i "s|#username|$username|g" "$file"
    else
        echo -e "\e[97;41mERROR: No se proporcionó un nombre de usuario válido\e[0m"
    fi
}

# Reemplazar etiquetas en el primer archivo
replace_labels "$docker_compose_file_1"

# Reemplazar etiquetas en el segundo archivo
replace_labels "$docker_compose_file_2"

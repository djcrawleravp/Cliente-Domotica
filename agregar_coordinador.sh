# Limpiar pantalla y Obtener la dirección del coordinador Zigbee
docker_compose_file="/home/djcrawleravp/docker/portainer/custom_templates/1/docker-compose.yml"
device_address=$(ls /dev/serial/by-id/ | grep "Texas_Instruments" | head -n 1)
if [ -n "$device_address" ]; then
    sed -i "s|devices:|#Coordinador_Zigbee|g" "$docker_compose_file"
    echo "  - /dev/serial/by-id/$device_address" >> "$docker_compose_file"
    clear
    echo "Coordinador añadido al template de Portainer"
else
    clear
    echo "No se detectó Coordinador Zigbee. Verifica que el dispositivo esté conectado"
fi

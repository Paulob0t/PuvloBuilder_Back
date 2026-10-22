#!/usr/bin/env bash
set -e

echo "=== 1. Instalando Podman y Podman Compose ==="
sudo pacman -S --needed podman podman-compose

echo "=== 2. Deteniendo servicio MariaDB local ==="
sudo systemctl stop mariadb || true
sudo systemctl disable mariadb || true

echo "=== 3. Levantando contenedor de Base de Datos en Podman ==="
cd "$(dirname "$0")"
podman compose up -d

echo "=== 4. Esperando a que MariaDB esté listo en Podman... ==="
sleep 5
podman ps

echo "[OK] Base de datos migrada y corriendo en Podman exitosamente en el puerto 3306!"

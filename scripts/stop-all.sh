#!/usr/bin/env bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}🛑 Deteniendo todos los servicios de PuvloBuilder...${NC}"

# Stop processes on ports 3000 and 4000
echo -e "${BLUE}Cerrando procesos en puertos 3000 y 4000...${NC}"
fuser -k 3000/tcp 2>/dev/null || true
fuser -k 4000/tcp 2>/dev/null || true

# Stop Podman container
echo -e "${BLUE}Deteniendo contenedor MariaDB en Podman...${NC}"
podman stop puvlobuilder_mariadb 2>/dev/null || true

echo -e "${GREEN}✅ ¡Todos los servicios han sido detenidos con éxito!${NC}"

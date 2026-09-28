#!/usr/bin/env bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FRONT_DIR="$(cd "$BACK_DIR/../PuvloBuilder_Front" && pwd)"

echo -e "${BOLD}${BLUE}====================================================${NC}"
echo -e "${BOLD}${BLUE}       🚀 INICIANDO ENTORNO PUVLOBUILDER 🚀         ${NC}"
echo -e "${BOLD}${BLUE}====================================================${NC}\n"

# 1. Iniciar Base de Datos en Podman
echo -e "${YELLOW}📦 [1/3] Verificando Base de Datos en Podman...${NC}"
if podman ps --filter "name=puvlobuilder_mariadb" --filter "status=running" --format "{{.Names}}" | grep -q "puvlobuilder_mariadb"; then
    echo -e "${GREEN}   ✔ MariaDB en Podman ya se encuentra corriendo.${NC}"
elif podman ps -a --filter "name=puvlobuilder_mariadb" --format "{{.Names}}" | grep -q "puvlobuilder_mariadb"; then
    echo -e "${BLUE}   Iniciando contenedor puvlobuilder_mariadb...${NC}"
    podman start puvlobuilder_mariadb > /dev/null
    echo -e "${GREEN}   ✔ Contenedor MariaDB iniciado exitosamente.${NC}"
else
    echo -e "${BLUE}   Creando contenedor MariaDB con Podman Compose...${NC}"
    (cd "$BACK_DIR" && podman compose up -d)
    echo -e "${GREEN}   ✔ Contenedor MariaDB creado e iniciado.${NC}"
fi

sleep 1

# 2. Iniciar Backend
echo -e "\n${YELLOW}⚙️  [2/3] Iniciando Backend en puerto 4000...${NC}"
cd "$BACK_DIR"
npm run dev &
BACK_PID=$!

# 3. Iniciar Frontend
echo -e "\n${YELLOW}🎨 [3/3] Iniciando Frontend en puerto 3000...${NC}"
cd "$FRONT_DIR"
npm run dev -- --host &
FRONT_PID=$!

# Handler para cerrar todo al presionar Ctrl+C
cleanup() {
    echo -e "\n\n${YELLOW}🛑 Deteniendo servicios del proyecto...${NC}"
    kill $BACK_PID 2>/dev/null || true
    kill $FRONT_PID 2>/dev/null || true
    echo -e "${GREEN}✔ Servidores Node.js detenidos.${NC}"
    
    read -p "¿Deseas detener también el contenedor de Podman? (s/N): " stop_podman
    if [[ "$stop_podman" =~ ^[sS]$ ]]; then
        echo -e "${BLUE}Deteniendo contenedor Podman...${NC}"
        podman stop puvlobuilder_mariadb > /dev/null 2>&1 || true
        echo -e "${GREEN}✔ Contenedor Podman detenido.${NC}"
    else
        echo -e "${BLUE}Contenedor Podman continúa activo en segundo plano.${NC}"
    fi
    echo -e "${GREEN}✨ ¡Hasta luego!${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

echo -e "\n${BOLD}${GREEN}====================================================${NC}"
echo -e "${BOLD}${GREEN}  ✅ ¡TODO EL ENTORNO ESTÁ ACTIVO Y FUNCIONANDO!   ${NC}"
echo -e "${BOLD}${GREEN}====================================================${NC}"
echo -e "  🌐 Frontend:  ${BOLD}http://localhost:3000${NC}"
echo -e "  ⚙️  Backend:   ${BOLD}http://localhost:4000${NC}"
echo -e "  📦 Base Datos: ${BOLD}localhost:3306 (Podman)${NC}"
echo -e "----------------------------------------------------"
echo -e "  ${YELLOW}Presiona [Ctrl + C] en esta terminal para apagar todo.${NC}\n"

# Mantener vivo el script
wait

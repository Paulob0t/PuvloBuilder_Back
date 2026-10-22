#!/usr/bin/env bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# Ensure PATH includes pnpm / npm
export PNPM_HOME="$HOME/.local/share/pnpm"
for p in "$PNPM_HOME/bin" "$HOME/.local/bin" "/usr/local/bin"; do
    if [[ -d "$p" && ":$PATH:" != *":$p:"* ]]; then
        export PATH="$p:$PATH"
    fi
done

NPM_BIN="$(command -v npm 2>/dev/null || echo "$PNPM_HOME/bin/npm")"
if [[ ! -x "$NPM_BIN" ]]; then
    echo -e "${RED}[ERROR] No se encontro ejecutable npm en el sistema.${NC}"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACK_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
FRONT_DIR="$(cd "$BACK_DIR/../PuvloBuilder_Front" && pwd)"

if [[ ! -d "$FRONT_DIR" ]]; then
    echo -e "${RED}[ERROR] No se encontro directorio de frontend en: $FRONT_DIR${NC}"
    exit 1
fi

echo -e "${BOLD}${BLUE}====================================================${NC}"
echo -e "${BOLD}${BLUE}          INICIANDO ENTORNO PUVLOBUILDER            ${NC}"
echo -e "${BOLD}${BLUE}====================================================${NC}\n"

# 1. Iniciar Base de Datos en Podman
echo -e "${YELLOW}[1/3] Verificando Base de Datos en Podman...${NC}"
if podman ps --filter "name=puvlobuilder_mariadb" --filter "status=running" --format "{{.Names}}" | grep -q "puvlobuilder_mariadb"; then
    echo -e "${GREEN}   [OK] MariaDB en Podman ya se encuentra corriendo.${NC}"
elif podman ps -a --filter "name=puvlobuilder_mariadb" --format "{{.Names}}" | grep -q "puvlobuilder_mariadb"; then
    echo -e "${BLUE}   Iniciando contenedor puvlobuilder_mariadb...${NC}"
    podman start puvlobuilder_mariadb > /dev/null
    echo -e "${GREEN}   [OK] Contenedor MariaDB iniciado exitosamente.${NC}"
else
    echo -e "${BLUE}   Creando contenedor MariaDB con Podman Compose...${NC}"
    (cd "$BACK_DIR" && podman compose up -d)
    echo -e "${GREEN}   [OK] Contenedor MariaDB creado e iniciado.${NC}"
fi

# Esperar a que MariaDB este listo para conexiones reales
echo -e "${BLUE}   Esperando disponibilidad de MariaDB en puerto 3306...${NC}"
READY=0
for i in {1..30}; do
    if podman exec puvlobuilder_mariadb mariadb-admin ping -u root -proot_password_puvlo_2026 >/dev/null 2>&1; then
        READY=1
        break
    fi
    sleep 0.5
done

if [[ $READY -eq 1 ]]; then
    echo -e "${GREEN}   [OK] MariaDB listo para aceptar conexiones.${NC}"
else
    echo -e "${YELLOW}   [WARN] No se confirmo ping a MariaDB aun; continuando...${NC}"
fi

# 2. Iniciar Backend
echo -e "\n${YELLOW}[2/3] Iniciando Backend en puerto 4000...${NC}"
(cd "$BACK_DIR" && "$NPM_BIN" run dev) &
BACK_PID=$!

# 3. Iniciar Frontend
echo -e "\n${YELLOW}[3/3] Iniciando Frontend en puerto 3000...${NC}"
(cd "$FRONT_DIR" && "$NPM_BIN" run dev -- --host) &
FRONT_PID=$!

# Handler para cerrar todo al presionar Ctrl+C o salir
cleanup() {
    trap - SIGINT SIGTERM EXIT
    echo -e "\n\n${YELLOW}[!] Deteniendo servicios del proyecto...${NC}"
    kill $BACK_PID 2>/dev/null || true
    kill $FRONT_PID 2>/dev/null || true
    fuser -k 3000/tcp 2>/dev/null || true
    fuser -k 4000/tcp 2>/dev/null || true
    echo -e "${GREEN}[OK] Servidores Node.js detenidos.${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

echo -e "\n${BOLD}${GREEN}====================================================${NC}"
echo -e "${BOLD}${GREEN}    TODO EL ENTORNO ESTA ACTIVO Y FUNCIONANDO       ${NC}"
echo -e "${BOLD}${GREEN}====================================================${NC}"
echo -e "  Frontend:    ${BOLD}http://localhost:3000${NC}"
echo -e "  Backend:     ${BOLD}http://localhost:4000${NC}"
echo -e "  Base Datos:  ${BOLD}localhost:3306 (Podman)${NC}"
echo -e "----------------------------------------------------"
echo -e "  ${YELLOW}Presiona [Ctrl + C] en esta terminal para apagar todo.${NC}\n"

wait

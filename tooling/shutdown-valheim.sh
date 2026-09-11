#!/bin/bash
set -euo pipefail

CONTAINER="valheim-server"

echo "[shutdown] Parando Valheim graciosamente..."

docker stop -t 120 "$CONTAINER"

echo "[shutdown] Valheim terminou."

# Backup depois do save
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p /srv/valheim/shutdown-backups

tar -czf \
  "/srv/valheim/shutdown-backups/world-${TIMESTAMP}.tar.gz" \
  -C /srv/valheim/config \
  worlds_local

echo "[shutdown] Backup final concluído."

sync

echo "[shutdown] Desligando VM..."

sudo systemctl poweroff
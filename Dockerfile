# syntax=docker/dockerfile:1

FROM ghcr.io/community-valheim-tools/valheim-server:latest

ARG NORAIN_VERSION=1.3.0

LABEL org.opencontainers.image.title="jfh-valheim"
LABEL org.opencontainers.image.description="Valheim dedicated server with NoRainDamage"
LABEL jfh.mods.NoRainDamage="${NORAIN_VERSION}"

RUN set -eux; \
    mkdir -p /opt/jfh-mods; \
    mkdir -p /tmp/norain; \
    curl \
      --fail \
      --silent \
      --show-error \
      --location \
      --retry 3 \
      --output /tmp/norain.zip \
      "https://thunderstore.io/package/download/JoelOliMclean/NoRainDamage/${NORAIN_VERSION}/"; \
    unzip -q /tmp/norain.zip -d /tmp/norain; \
    test -d /tmp/norain/BepInEx/plugins; \
    cp -a /tmp/norain/BepInEx/plugins/. /opt/jfh-mods/; \
    test -f /opt/jfh-mods/Jowleth/NoRainDamage.dll; \
    rm -rf /tmp/norain /tmp/norain.zip

RUN cat > /usr/local/sbin/jfh-bootstrap <<'EOF'

#!/bin/bash
set -euo pipefail

SOURCE="/opt/jfh-mods"
TARGET="/config/bepinex/plugins"

echo "[jfh] Instalando plugins..."

mkdir -p "${TARGET}"

rm -rf "${TARGET}/NoRainDamage"

cp -a "${SOURCE}/." "${TARGET}/"

echo "[jfh] Plugins instalados:"
find "${TARGET}" -type f -name '*.dll' -printf '[jfh]   %P\n'

echo "[jfh] Iniciando bootstrap original..."

exec /usr/local/sbin/bootstrap
EOF

RUN chmod 755 /usr/local/sbin/jfh-bootstrap

CMD ["/usr/local/sbin/jfh-bootstrap"]
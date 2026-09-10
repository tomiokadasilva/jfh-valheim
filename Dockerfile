# syntax=docker/dockerfile:1

FROM ghcr.io/community-valheim-tools/valheim-server:latest

ARG NORAIN_VERSION=1.3.0

LABEL org.opencontainers.image.title="jfh-valheim"
LABEL org.opencontainers.image.description="Valheim dedicated server with NoRainDamage"
LABEL jfh.mods.NoRainDamage="${NORAIN_VERSION}"

#
# A imagem upstream já possui curl e unzip.
# Baixamos o pacote no build e armazenamos fora de /config,
# pois /config será sobrescrito pelo volume persistente no runtime.
#
RUN set -eux; \
    mkdir -p /opt/jfh-mods/NoRainDamage; \
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
    cp -a /tmp/norain/. /opt/jfh-mods/NoRainDamage/; \
    test -n "$(find /opt/jfh-mods/NoRainDamage -type f -name '*.dll' -print -quit)"; \
    rm -rf /tmp/norain /tmp/norain.zip

#
# Wrapper executado antes do bootstrap oficial.
#
# O volume /config já estará montado neste momento.
# Instalamos somente os arquivos gerenciados por nossa imagem.
#
RUN cat > /usr/local/sbin/jfh-bootstrap <<'EOF'
#!/bin/bash
set -euo pipefail

SOURCE="/opt/jfh-mods/NoRainDamage"
TARGET="/config/bepinex/plugins/NoRainDamage"

echo "[jfh] Instalando NoRainDamage..."

mkdir -p "${TARGET}"

# Esta pasta pertence à nossa imagem.
# Remove versão anterior antes de copiar a versão atual.
find "${TARGET}" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

cp -a "${SOURCE}/." "${TARGET}/"

echo "[jfh] NoRainDamage instalado:"
find "${TARGET}" -type f -printf '[jfh]   %P\n'

echo "[jfh] Iniciando bootstrap original..."

exec /usr/local/sbin/bootstrap
EOF

RUN chmod 755 /usr/local/sbin/jfh-bootstrap

CMD ["/usr/local/sbin/jfh-bootstrap"]
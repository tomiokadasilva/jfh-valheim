# syntax=docker/dockerfile:1

FROM ghcr.io/community-valheim-tools/valheim-server:latest

ARG NORAIN_VERSION=1.3.2
ARG PLANTEVERYTHING_VERSION=1.21.3
ARG ACHIEVEMENT_ENABLER_PLUS_VERSION=2.0.3
ARG AZUCRAFTYBOXES_VERSION=1.8.19
ARG BETTERNETWORKING_VALHEIM_VERSION=1.2.0
ARG JOTUNN_VERSION=2.30.2
ARG NETWORK_PERFORMANCE_SYSTEM_VERSION=1.11.0

LABEL org.opencontainers.image.title="jfh-valheim"

LABEL org.opencontainers.image.description="Valheim dedicated server with NoRainDamage, PlantEverything, Achievement Enabler Plus, AzuCraftyBoxes and BetterNetworking"
LABEL jfh.mods.NoRainDamage="${NORAIN_VERSION}"
LABEL jfh.mods.PlantEverything="${PLANTEVERYTHING_VERSION}"
LABEL jfh.mods.AchievementEnablerPlus="${ACHIEVEMENT_ENABLER_PLUS_VERSION}"
LABEL jfh.mods.AzuCraftyBoxes="${AZUCRAFTYBOXES_VERSION}"
LABEL jfh.mods.BetterNetworking_Valheim="${BETTERNETWORKING_VALHEIM_VERSION}"
LABEL jfh.mods.Jotunn="${JOTUNN_VERSION}"
LABEL jfh.mods.NetworkPerformanceSystem="${NETWORK_PERFORMANCE_SYSTEM_VERSION}"

RUN set -eux; \
  mkdir -p /opt/jfh-mods

RUN set -eux; \
  echo "[build] Instalando NoRainDamage ${NORAIN_VERSION}"; \
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

RUN set -eux; \
  echo "[build] Instalando PlantEverything ${PLANTEVERYTHING_VERSION}"; \
  mkdir -p /tmp/planteverything; \
  curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --retry 3 \
  --output /tmp/planteverything.zip \
  "https://thunderstore.io/package/download/Advize/PlantEverything/${PLANTEVERYTHING_VERSION}/"; \
  unzip -q /tmp/planteverything.zip -d /tmp/planteverything; \
  test -f /tmp/planteverything/Advize_PlantEverything.dll; \
  cp /tmp/planteverything/Advize_PlantEverything.dll /opt/jfh-mods/; \
  test -f /opt/jfh-mods/Advize_PlantEverything.dll; \
  rm -rf /tmp/planteverything /tmp/planteverything.zip

RUN set -eux; \
  echo "[build] Instalando Achievement Enabler Plus ${ACHIEVEMENT_ENABLER_PLUS_VERSION}"; \
  mkdir -p /tmp/achievement; \
  curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --retry 3 \
  --output /tmp/achievement.zip \
  "https://thunderstore.io/package/download/RobgobStuff/Achievement_Enabler_Plus/${ACHIEVEMENT_ENABLER_PLUS_VERSION}/"; \
  unzip -q /tmp/achievement.zip -d /tmp/achievement; \
  test -d /tmp/achievement/BepInEx/plugins/AchievementEnablerPlus; \
  cp -a /tmp/achievement/BepInEx/plugins/. /opt/jfh-mods/; \
  test -f /opt/jfh-mods/AchievementEnablerPlus/AchievementEnablerPlus.dll; \
  rm -rf /tmp/achievement /tmp/achievement.zip

RUN set -eux; \
  echo "[build] Instalando AzuCraftyBoxes ${AZUCRAFTYBOXES_VERSION}"; \
  mkdir -p /tmp/azucrafty; \
  curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --retry 3 \
  --output /tmp/azucrafty.zip \
  "https://thunderstore.io/package/download/Azumatt/AzuCraftyBoxes/${AZUCRAFTYBOXES_VERSION}/"; \
  unzip -q /tmp/azucrafty.zip -d /tmp/azucrafty; \
  test -f /tmp/azucrafty/AzuCraftyBoxes.dll; \
  cp /tmp/azucrafty/AzuCraftyBoxes.dll /opt/jfh-mods/; \
  test -f /opt/jfh-mods/AzuCraftyBoxes.dll; \
  rm -rf /tmp/azucrafty /tmp/azucrafty.zip

RUN set -eux; \
  echo "[build] Instalando BetterNetworking_Valheim ${BETTERNETWORKING_VALHEIM_VERSION}"; \
  mkdir -p /tmp/betternetworking /opt/jfh-mods/BetterNetworking_Valheim; \
  curl --fail --silent --show-error --location --retry 3 \
  --output /tmp/betternetworking.zip \
  "https://thunderstore.io/package/download/SimplifyDave/BetterNetworking_Valheim/${BETTERNETWORKING_VALHEIM_VERSION}/"; \
  unzip -t /tmp/betternetworking.zip; \
  unzip_status=0; \
  unzip -q /tmp/betternetworking.zip -d /tmp/betternetworking || unzip_status=$?; \
  find /tmp/betternetworking -type f -print; \
  dll_path="$(find /tmp/betternetworking -type f -name 'DIT.BetterNetworking10.dll' -print -quit)"; \
  if [ -z "${dll_path}" ]; then \
  exit 1; \
  fi; \
  cp "${dll_path}" /opt/jfh-mods/BetterNetworking_Valheim/


RUN set -eux; \
  echo "[build] Instalando Jotunn ${JOTUNN_VERSION}"; \
  mkdir -p /tmp/jotunn /opt/jfh-mods/Jotunn; \
  curl --fail --silent --show-error --location --retry 3 \
  --output /tmp/jotunn.zip \
  "https://thunderstore.io/package/download/ValheimModding/Jotunn/${JOTUNN_VERSION}/"; \
  unzip -t /tmp/jotunn.zip; \
  unzip_status=0; \
  unzip -q /tmp/jotunn.zip -d /tmp/jotunn || unzip_status=$?; \
  dll_path="$(find /tmp/jotunn/plugins -type f -name 'Jotunn.dll' -print -quit)"; \
  if [ -z "${dll_path}" ]; then \
  echo "[build] ERROR: Jotunn.dll not found"; \
  exit 1; \
  fi; \
  echo "[build] Found DLL at: ${dll_path}"; \
  cp "${dll_path}" /opt/jfh-mods/Jotunn/; \
  test -f /opt/jfh-mods/Jotunn/Jotunn.dll; \
  rm -rf /tmp/jotunn /tmp/jotunn.zip

RUN set -eux; \
  echo "[build] Instalando NetworkPerformanceSystem ${NETWORK_PERFORMANCE_SYSTEM_VERSION}"; \
  mkdir -p /tmp/networkperformance /opt/jfh-mods/NetworkPerformanceSystem; \
  curl --fail --silent --show-error --location --retry 3 \
  --output /tmp/networkperformance.zip \
  "https://thunderstore.io/package/download/MidnightMods/NetworkPerformanceSystem/${NETWORK_PERFORMANCE_SYSTEM_VERSION}/"; \
  unzip -t /tmp/networkperformance.zip; \
  unzip_status=0; \
  unzip -q /tmp/networkperformance.zip -d /tmp/networkperformance; \
  dll_path="$(find /tmp/networkperformance/plugins -type f -name 'NetworkPerformanceSystem.dll' -print -quit)"; \
  if [ -z "${dll_path}" ]; then \
  echo "[build] ERROR: NetworkPerformanceSystem.dll not found"; \
  exit 1; \
  fi; \
  echo "[build] Found DLL at: ${dll_path}"; \
  cp "${dll_path}" /opt/jfh-mods/NetworkPerformanceSystem/; \
  test -f /opt/jfh-mods/NetworkPerformanceSystem/NetworkPerformanceSystem.dll; \
  rm -rf /tmp/networkperformance /tmp/networkperformance.zip

RUN cat > /usr/local/sbin/jfh-bootstrap <<'EOF'
#!/bin/bash
set -euo pipefail

SOURCE="/opt/jfh-mods"
TARGET="/config/bepinex/plugins"

echo "[jfh] Instalando plugins em ${TARGET}..."

mkdir -p "${TARGET}"

rm -rf "${TARGET}/Jotunn"
rm -rf "${TARGET}/Jowleth"
rm -rf "${TARGET}/AchievementEnablerPlus"
rm -rf "${TARGET}/BetterNetworking_Valheim"
rm -f  "${TARGET}/Advize_PlantEverything.dll"
rm -rf "${TARGET}/AzuCraftyBoxes"
rm -f  "${TARGET}/AzuCraftyBoxes.dll"
rm -f  "${TARGET}/AchievementEligibility.dll"
rm -f  "${TARGET}/ValheimItemSanitizer.dll"

cp -a "${SOURCE}/." "${TARGET}/"

echo "[jfh] Plugins instalados:"
find "${TARGET}" -type f -name '*.dll' -printf '[jfh]   %P\n'

echo "[jfh] Iniciando bootstrap original..."

exec /usr/local/sbin/bootstrap
EOF

RUN chmod 755 /usr/local/sbin/jfh-bootstrap

ENV BEPINEX=true

CMD ["/usr/local/sbin/jfh-bootstrap"]
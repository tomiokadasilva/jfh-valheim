# syntax=docker/dockerfile:1

FROM ghcr.io/community-valheim-tools/valheim-server:latest

ARG NORAIN_VERSION=1.3.0
ARG PLANTEVERYTHING_VERSION=1.21.2
ARG ACHIEVEMENT_ENABLER_PLUS_VERSION=2.0.3
ARG BETTERNETWORKING_VERSION=1.2.0
ARG AZUCRAFTYBOXES_VERSION=1.8.19

LABEL org.opencontainers.image.title="jfh-valheim"
LABEL org.opencontainers.image.description="Valheim dedicated server with NoRainDamage, PlantEverything, Achievement Enabler Plus, BetterNetworking and AzuCraftyBoxes"
LABEL jfh.mods.NoRainDamage="${NORAIN_VERSION}"
LABEL jfh.mods.PlantEverything="${PLANTEVERYTHING_VERSION}"
LABEL jfh.mods.AchievementEnablerPlus="${ACHIEVEMENT_ENABLER_PLUS_VERSION}"
LABEL jfh.mods.BetterNetworking="${BETTERNETWORKING_VERSION}"
LABEL jfh.mods.AzuCraftyBoxes="${AZUCRAFTYBOXES_VERSION}"

RUN set -eux; \
  mkdir -p /opt/jfh-mods; \
  \
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
  \
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
  \
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
  test -d /tmp/achievement/plugins/AchievementEnablerPlus; \
  cp -a /tmp/achievement/plugins/AchievementEnablerPlus /opt/jfh-mods/; \
  test -d /tmp/achievement/BepInEx/plugins/AchievementEnablerPlus; \
  cp -a /tmp/achievement/BepInEx/plugins/. /opt/jfh-mods/; \
  test -f /opt/jfh-mods/AchievementEnablerPlus/AchievementEnablerPlus.dll; \
  \
  echo "[build] Instalando BetterNetworking ${BETTERNETWORKING_VERSION}"; \
  mkdir -p /tmp/betternetworking; \
  curl \
  --fail \
  --silent \
  --show-error \
  --location \
  --retry 3 \
  --output /tmp/betternetworking.zip \
  "https://thunderstore.io/package/download/SimplifyDave/BetterNetworking_Valheim/${BETTERNETWORKING_VERSION}/"; \
  unzip -q /tmp/betternetworking.zip -d /tmp/betternetworking; \
  test -d /tmp/betternetworking/BepInEx/plugins/BetterNetworking_Valheim; \
  cp -a /tmp/betternetworking/BepInEx/plugins/BetterNetworking_Valheim /opt/jfh-mods/; \
  test -f /opt/jfh-mods/BetterNetworking_Valheim/DIT.BetterNetworking10.dll; \
  \
  echo "[build] Instalando AzuCraftyBoxes ${AZUCRAFTYBOXES_VERSION}"; \
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
  test -d /tmp/azucrafty/plugins/Azumatt-AzuCraftyBoxes; \
  cp -a /tmp/azucrafty/plugins/Azumatt-AzuCraftyBoxes /opt/jfh-mods/; \
  test -f /opt/jfh-mods/Azumatt-AzuCraftyBoxes/AzuCraftyBoxes.dll; \
  \
  test -f /tmp/azucrafty/AzuCraftyBoxes.dll; \
  cp /tmp/azucrafty/AzuCraftyBoxes.dll /opt/jfh-mods/; \
  test -f /opt/jfh-mods/AzuCraftyBoxes.dll; \
  echo "[build] Plugins empacotados:"; \
  find /opt/jfh-mods -type f -name '*.dll' -print; \
  \
  rm -rf \
  /tmp/norain \
  /tmp/norain.zip \
  /tmp/planteverything \
  /tmp/planteverything.zip \
  /tmp/achievement \
  /tmp/achievement.zip \
  /tmp/betternetworking \
  /tmp/betternetworking.zip \
  /tmp/azucrafty \
  /tmp/azucrafty.zip

RUN cat > /usr/local/sbin/jfh-bootstrap <<'EOF'
#!/bin/bash
set -euo pipefail

SOURCE="/opt/jfh-mods"
TARGET="/config/bepinex/plugins"

echo "[jfh] Instalando plugins em ${TARGET}..."

mkdir -p "${TARGET}"

rm -rf "${TARGET}/Jowleth"
rm -rf "${TARGET}/AchievementEnablerPlus"
rm -rf "${TARGET}/BetterNetworking_Valheim"
rm -rf "${TARGET}/Azumatt-AzuCraftyBoxes"
rm -f "${TARGET}/Advize_PlantEverything.dll"
rm -f  "${TARGET}/Advize_PlantEverything.dll"
rm -f  "${TARGET}/DIT.BetterNetworking10.dll"
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
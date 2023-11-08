#!/bin/bash -ex
TARGET_USER=cirrascale
DOWNLOADS_PATH=/home/${TARGET_USER}/
QAIC_VERSION=1.11.0.112
PLATFORM_SDK_ZIP=qaic-platform-sdk-x86_64-deb-${QAIC_VERSION}.zip
PLATFORM_SDK=qaic-platform-sdk-${QAIC_VERSION}
APPS_SDK_ZIP=qaic-apps-${QAIC_VERSION}.zip
APPS_SDK=qaic-apps-${QAIC_VERSION}

# install platform SDK
cd ${DOWNLOADS_PATH}
unzip ${DOWNLOADS_PATH}/${PLATFORM_SDK_ZIP}
cd ${DOWNLOADS_PATH}/${PLATFORM_SDK}/x86_64/deb/
./install.sh --auto_upgrade_sbl --ecc enable

# install apps SDK
cd ${DOWNLOADS_PATH}
unzip ${DOWNLOADS_PATH}/${APPS_SDK_ZIP}
cd ${DOWNLOADS_PATH}/${APPS_SDK}
./install.sh
chmod a+x /opt/qti-aic/dev/hexagon_tools/bin/*
chmod a+x /opt/qti-aic/exec/*

# install qaic-pytools
cd ${DOWNLOADS_PATH}/${APPS_SDK}/tools/qaic-pytools/
./install.sh

# give user permissions for installed SDKs
chown -R ${TARGET_USER}:${TARGET_USER} /opt/qti-aic/
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${PLATFORM_SDK}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${PLATFORM_SDK_ZIP}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${APPS_SDK}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${APPS_SDK_ZIP}

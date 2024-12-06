#!/bin/bash -ex

if [[ -z $TARGET_USER ]]; then
  echo "TARGET_USER variable not set. Exiting..."
  exit
fi

if [[ -z $QAIC_VERSION ]]; then
  echo "QAIC_VERSION variable not set. Exiting..."
  exit
fi

#TARGET_USER=cirrascale
#QAIC_VERSION=x.x.x.x
CPU_ARCH=x86_64
DOWNLOADS_PATH=/home/${TARGET_USER}/
PLATFORM_SDK_ZIP=aic_platform.Core.${QAIC_VERSION}.Linux-AnyCPU.zip
PLATFORM_SDK=qaic-platform-sdk-${QAIC_VERSION}
APPS_SDK_ZIP=aic_apps.Core.${QAIC_VERSION}.Linux-AnyCPU.zip
APPS_SDK=qaic-apps-${QAIC_VERSION}

# install platform SDK
unzip ${DOWNLOADS_PATH}/${PLATFORM_SDK_ZIP} -d ${DOWNLOADS_PATH}
cd ${DOWNLOADS_PATH}/${PLATFORM_SDK}/${CPU_ARCH}/deb/ && ./install.sh --auto_upgrade_sbl --ecc enable --setup_mdp all

# install apps SDK
unzip ${DOWNLOADS_PATH}/${APPS_SDK_ZIP} -d ${DOWNLOADS_PATH}
cd ${DOWNLOADS_PATH}/${APPS_SDK} && ./install.sh --enable-qaic-pytools
chmod a+x /opt/qti-aic/dev/hexagon_tools/bin/*
chmod a+x /opt/qti-aic/exec/*

# give user permissions for installed SDKs
chown -R ${TARGET_USER}:${TARGET_USER} /opt/qti-aic/
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${PLATFORM_SDK}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${PLATFORM_SDK_ZIP}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${APPS_SDK}
chown -R ${TARGET_USER}:${TARGET_USER} ${DOWNLOADS_PATH}/${APPS_SDK_ZIP}

# add target user to qaic group for sudoless access to qaic apps/tools
usermod -aG qaic $TARGET_USER

# add environment variables
cat > /etc/profile.d/cirrascale-Qualcomm-AI100.sh << 'EOF'
export LD_LIBRARY_PATH=“$LD_LIBRARY_PATH:/opt/qti-aic/dev/lib/x86_64” 
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/opt/qti-aic/tools:/opt/qti-aic/exec:/opt/qti-aic/scripts" 
export QAIC_EXAMPLES="/opt/qti-aic/examples" 
export QAIC_APPS="/opt/qti-aic/examples/apps" 
export QAIC_LIB="/opt/qti-aic/dev/lib/x86_64/libQAic.so" 
export QAIC_COMPILER_LIB="/opt/qti-aic/dev/lib/x86_64/libQAicCompiler.so"
EOF

#!/bin/bash -ex
TARGET_USER=cirrascale

# Qualcomm AI 100 Specific
apt update
apt-get install dkms -y
apt-get install linux-headers-$(uname -r) -y
apt-get update && apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt-get update && apt-get install -y build-essential git vim libpci-dev libudev-dev python3-pip python3-setuptools python3-wheel python3.8 python3.8-dev python3.8-venv
apt-get update && apt-get install -y unzip wget ca-certificates pciutils libglib2.0-dev libssl-dev snap snapd libgl1-mesa-glx pkg-config clang-format libpng-dev
apt-get install libstdc++6 -y
apt-get install libncurses5 -y

pip3 install --upgrade pip
pip3 install wheel numpy opencv-python onnx

cat > /etc/profile.d/cirrascale-Qualcomm-AI100.sh << 'EOF'
export LD_LIBRARY_PATH=“$LD_LIBRARY_PATH:/opt/qti-aic/dev/lib/x86_64” 
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:/opt/qti-aic/tools:/opt/qti-aic/exec:/opt/qti-aic/scripts" 
export QRAN_EXAMPLES="/opt/qti-aic/examples" 
export PYTHONPATH="$PYTHONPATH:/opt/qti-aic/dev/lib/x86_64"
export QAIC_APPS="/opt/qti-aic/examples/apps" 
export QAIC_LIB="/opt/qti-aic/dev/lib/x86_64/libQAic.so" 
export QAIC_COMPILER_LIB="/opt/qti-aic/dev/lib/x86_64/libQAicCompiler.so"
# Apps SDK
export AIC_COMPILER_LIB_DIR=/opt/qti-aic/dev/lib/x86_64/apps:/opt/qti-aic/dev/lib/x86_64/
export AIC_COMPILER_TOOLS_DIR=/opt/qti-aic/dev/hexagon_tools/
EOF

# docker support
apt install docker.io -y
usermod -aG docker $TARGET_USER
#!/bin/bash -ex
TARGET_USER=cirrascale

# Qualcomm AI 100 Specific
apt update
apt-get install dkms -y
apt-get install linux-headers-$(uname -r) -y
apt-get update && apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test -y
add-apt-repository ppa:deadsnakes/ppa -y
apt-get update && apt-get install -y build-essential git less vim-tiny nano libpci-dev libudev-dev libatomic1 python3-pip python3-setuptools python3-wheel python3.8 python3.8-dev python3.8-venv python3.10-venv
apt-get update && apt-get install -y unzip zip wget ca-certificates sudo pciutils libglib2.0-dev libssl-dev snap snapd openssh-server pkg-config clang-format libpng-dev gpg
apt-get install libstdc++6 -y
apt-get install libncurses5-dev -y

python3.8 -m pip install --upgrade pip
python3.8 -m pip install wheel numpy opencv-python onnx pyudev networkx

# docker support
curl https://get.docker.com | bash
usermod -aG docker $TARGET_USER

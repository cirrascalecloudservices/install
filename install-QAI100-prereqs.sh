#!/bin/bash -ex
TARGET_USER=cirrascale

# Qualcomm AI 100 Specific
apt update
apt-get install dkms -y
apt-get install linux-headers-$(uname -r) -y
apt-get update && apt-get install -y software-properties-common
add-apt-repository ppa:ubuntu-toolchain-r/test -y
add-apt-repository ppa:deadsnakes/ppa -y
apt-get update && apt-get install -y build-essential git vim libpci-dev libudev-dev python3-pip python3-setuptools python3-wheel python3.8 python3.8-dev python3.8-venv
apt-get update && apt-get install -y unzip wget ca-certificates pciutils libglib2.0-dev libssl-dev snap snapd libgl1-mesa-glx pkg-config clang-format libpng-dev
apt-get install libstdc++6 -y
apt-get install libncurses5 -y

pip3 install --upgrade pip
pip3 install wheel numpy opencv-python onnx pyudev
python3.8 -m pip install --upgrade pip
python3.8 -m pip install wheel numpy opencv-python onnx pyudev

# docker support
apt install docker.io -y
usermod -aG docker $TARGET_USER

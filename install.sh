#!/bin/sh

# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html
curl -sL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add -
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list

# https://github.com/NVIDIA/nvidia-container-runtime
curl -sL https://nvidia.github.io/nvidia-container-runtime/gpgkey | apt-key add -
curl -sL https://nvidia.github.io/nvidia-container-runtime/ubuntu20.04/nvidia-container-runtime.list > /etc/apt/sources.list.d/nvidia-container-runtime.list

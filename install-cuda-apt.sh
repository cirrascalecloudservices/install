#!/bin/sh -x

# https://developer.nvidia.com/cuda-toolkit-archive

systemctl set-default multi-user.target

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
sudo apt-get update

if [ $CUDA_VERSION ]; then
	apt-get -y install cuda=$CUDA_VERSION
	apt-mark hold cuda
fi

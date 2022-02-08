#!/bin/sh -x

systemctl set-default multi-user.target

echo 'cirrascale ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/cirrascale

# install nvidia cuda
# https://developer.nvidia.com/cuda-toolkit-archive
# e.g., https://developer.download.nvidia.com/compute/cuda/11.5.1/local_installers/cuda-repo-ubuntu2004-11-5-local_11.5.1-495.29.05-1_amd64.deb
if [ $CUDA_URL ]; then

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget $CUDA_URL
sudo dpkg -i $(basename $CUDA_URL)
sudo apt-key add /var/cuda-repo-ubuntu2004-*-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

fi

(cd /etc/profile.d && wget https://raw.githubusercontent.com/cirrascalecloudservices/install/main/etc/profile.d/cirrascale.sh)

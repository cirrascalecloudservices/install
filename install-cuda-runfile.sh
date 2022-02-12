#!/bin/sh -ex

rmmod nouveau
apt install -y dkms
systemctl set-default multi-user.target

# https://developer.nvidia.com/cuda-toolkit-archive
wget ${RUNFILE_URL?}
sh $(basename ${RUNFILE_URL?}) --silent

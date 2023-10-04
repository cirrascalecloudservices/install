#!/bin/bash -ex

# sudo sh -c "$(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/main/install-cuda.sh)"

. /etc/os-release

systemctl set-default multi-user.target

# https://developer.nvidia.com/cuda-toolkit-archive
arch=x86_64
distro=ubuntu$(echo $VERSION_ID | tr -d .)

# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212772
dpkg -i $(basename $(curl -s -w "%{url_effective}" https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.0-1_all.deb -O)) && apt-get update -y

if [ $CUDA ]; then
	apt-get install cuda-toolkit-$CUDA -y
fi

if [ $CUDA_DRIVER ]; then
	apt-get install cuda-drivers-$CUDA_DRIVER -y
	if [ $CUDA_DRIVER_FABRICMANAGER ]; then
		apt-get install cuda-drivers-fabricmanager-$CUDA_DRIVER -y
		systemctl enable nvidia-fabricmanager
	fi
fi

if [ $CUDNN ]; then
	apt-get install libcudnn8=$CUDNN -y && apt-mark hold libcudnn8
fi

# https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#debian-x86_64-deb
cat > /etc/profile.d/cirrascale-cuda.sh << 'EOF'
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

# prevent auto-upgrades from upgrading cuda and nvidia software
sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades <<EOF
Unattended-Upgrade::Package-Blacklist {"nvidia";"cuda";"libnvidia";"libcudnn";};  
EOF

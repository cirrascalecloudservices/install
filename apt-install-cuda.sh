#!/bin/sh -x

systemctl set-default multi-user.target

# https://developer.nvidia.com/cuda-toolkit-archive
# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212772
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin -O /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004-keyring.gpg
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
apt-get update

if [ $CUDA ]; then
	apt-get -y install cuda-toolkit-$CUDA
fi

if [ $CUDA_DRIVER ]; then
	apt-get -y install cuda-drivers-$CUDA_DRIVER
fi

###TODO fabricmanager here

if [ $CUDNN ]; then
	apt-get -y install libcudnn8=$CUDNN && apt-mark hold libcudnn8
fi

# https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#debian-x86_64-deb
cat > /etc/profile.d/cirrascale-cuda.sh << 'EOF'
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

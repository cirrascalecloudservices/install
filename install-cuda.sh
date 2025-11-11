#!/bin/bash -ex
# Example: CUDA= CUDA_DRIVER= CUDNN= NCCL= USE_OPEN_DRIVER= sh -c "$(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/Test/install-cuda.sh)"
# sudo sh -c "$(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/main/install-cuda.sh)"

# A100-HGX-nvswitch,H100/200-HGX-nvswitch,B200-HGX-SXM2,B300-HGX-SXM2
# (due to blackwell arch changes, nvswitch does not have its own pcie device)
NVSWITCH_PCIE_IDS="10de:1af1|10de:22a3|10de:2901|10de:3182"
# B200-HGX-SXM2, B300-HGX-SXM2
NVL5_GPU_PCIE_IDS="10de:2901|10de:3182"
. /etc/os-release

systemctl set-default multi-user.target

# https://developer.nvidia.com/cuda-toolkit-archive
arch=$(uname -m)
distro=ubuntu$(echo $VERSION_ID | tr -d .)

LATEST_CUDA_DRIVER=$(curl -s https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/ | grep -oP 'nvidia-driver-\K[0-9]+' | sort -n | tail -n 1)
NVSWITCH_FOUND=$(lspci -nn | grep -E "($NVSWITCH_PCIE_IDS)")
NVL5_FOUND=$(lspci -nn | grep -E "($NVL5_GPU_PCIE_IDS)")

# https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212772
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu
dpkg -i $(basename $(curl -s -w "%{url_effective}" https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.1-1_all.deb -O)) && apt-get update -y

# install kernel headers
apt-get install -y linux-headers-$(uname -r)

# install cuda library
if [ -n "$CUDA" ]; then
	apt-get install -y cuda-toolkit-$CUDA && apt-mark hold cuda-toolkit-$CUDA
	CUDA_MAJOR_VERSION=$(echo ${CUDA%-*})
else
	apt-get install -y cuda-toolkit && apt-mark hold cuda-toolkit
fi

# install latest cuda driver if one not set
if [ -z "$CUDA_DRIVER" ]; then
	CUDA_DRIVER=$LATEST_CUDA_DRIVER
fi

# setting $INSTALL_OPEN_DRIVER will force installing the open driver
# if $INSTALL_OPEN_DRIVER not set, check if GPU is open driver compatible
if [ -z "$INSTALL_OPEN_DRIVER" ]; then
	apt install -y nvidia-driver-assistant
	INSTALL_OPEN_DRIVER=$(nvidia-driver-assistant | grep "nvidia-open")
fi

# install nvidia open driver, else install nvidia proprietary driver
if [ -n "$INSTALL_OPEN_DRIVER" ]; then
	# Drivers that end in "5" are the "open" driver type
	# Drivers that end in "0" are the "server-open" driver type
	if [ $(($CUDA_DRIVER % 10)) -eq 0 ]; then
		OPEN_DRIVER_TYPE="server-open"
	else
		OPEN_DRIVER_TYPE="open"
	fi
	apt install -y nvidia-driver-$CUDA_DRIVER-$OPEN_DRIVER_TYPE && apt-mark hold nvidia-driver-$CUDA_DRIVER-$OPEN_DRIVER_TYPE
	if [ -n "$NVSWITCH_FOUND" ]; then
			apt-get install -y nvidia-fabricmanager-$CUDA_DRIVER && apt-mark hold nvidia-fabricmanager-$CUDA_DRIVER
			systemctl enable nvidia-fabricmanager.service
	fi
else
	if [ -n "$NVSWITCH_FOUND" ]; then
		apt-get install -y cuda-drivers-fabricmanager-$CUDA_DRIVER && apt-mark hold cuda-drivers-fabricmanager-$CUDA_DRIVER
		systemctl enable nvidia-fabricmanager.service
	else
		apt-get install -y cuda-drivers-$CUDA_DRIVER && apt-mark hold cuda-drivers-$CUDA_DRIVER
	fi
fi

# install nvlsm for Gen5 nvlink systems
if [ -n "$NVL5_FOUND" ]; then
	apt-get install -y nvlsm && apt-mark hold nvlsm
fi

# install cudnn
if [ -n "$CUDNN" -a -n "$CUDA_MAJOR_VERSION"]; then
	apt-get install -y libcudnn9-cuda-${CUDA_MAJOR_VERSION}=$CUDNN libcudnn9-dev-cuda-${CUDA_MAJOR_VERSION}=$CUDNN && apt-mark hold libcudnn9-cuda-${CUDA_MAJOR_VERSION}=$CUDNN libcudnn9-dev-cuda-${CUDA_MAJOR_VERSION}=$CUDNN
else
	apt-get install -y libcudnn9-cuda-13 libcudnn9-dev-cuda-13 && apt-mark hold libcudnn9-cuda-13 libcudnn9-dev-cuda-13
fi

# install nccl
if [ -n "$NCCL" ]; then
	apt-get install -y libnccl2=$NCCL libnccl-dev=$NCCL && apt-mark hold libnccl2=$NCCL libnccl-dev=$NCCL
else
	apt-get install -y libnccl2 libnccl-dev && apt-mark hold libnccl2 libnccl-dev
fi

# enable persistence (keeps GPUs initialized)
mkdir /etc/systemd/system/nvidia-persistenced.service.d/
echo "[Service]
ExecStart=
ExecStart=/usr/bin/nvidia-persistenced --user nvidia-persistenced --persistence-mode --verbose" > /etc/systemd/system/nvidia-persistenced.service.d/override.conf
systemctl enable nvidia-persistenced.service

# load nvidia-peermem module (enables RDMA GPU support)
echo "nvidia-peermem" | tee -a /etc/modules

# https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#debian-x86_64-deb
cat > /etc/profile.d/cirrascale-cuda.sh << 'EOF'
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

# prevent auto-upgrades from upgrading cuda and nvidia software
tee -a /etc/apt/apt.conf.d/50unattended-upgrades <<EOF
Unattended-Upgrade::Package-Blacklist {"nvidia";"cuda";"libnvidia";"libcudnn";"libnccl";"nvlsm";};  
EOF

# LOGGING
LOG_FILE=/root/install-cuda_log.txt
echo "arch: $arch" >> $LOG_FILE
echo "distro: $distro" >> $LOG_FILE
echo "LATEST_CUDA_DRIVER: $LATEST_CUDA_DRIVER" >> $LOG_FILE
echo "NVSWITCH_FOUND: $NVSWITCH_FOUND" >> $LOG_FILE
echo "NVL5_FOUND: $NVL5_FOUND" >> $LOG_FILE
echo "CUDA: $CUDA" >> $LOG_FILE
echo "CUDA_MAJOR_VERSION: $CUDA_MAJOR_VERSION" >> $LOG_FILE
echo "CUDA_DRIVER: $CUDA_DRIVER" >> $LOG_FILE
echo "INSTALL_OPEN_DRIVER: $INSTALL_OPEN_DRIVER" >> $LOG_FILE
echo "OPEN_DRIVER_TYPE: $OPEN_DRIVER_TYPE" >> $LOG_FILE
echo "CUDNN: $CUDNN" >> $LOG_FILE
echo "NCCL: $NCCL" >> $LOG_FILE
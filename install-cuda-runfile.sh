#!/bin/sh -ex

rmmod nouveau
apt install dkms
systemctl set-default multi-user.target

# https://developer.nvidia.com/cuda-toolkit-archive
wget ${RUNFILE_URL?}
sh $(basename ${RUNFILE_URL?}) --silent

# https://docs.nvidia.com/cuda/cuda-quick-start-guide/index.html#ubuntu-x86_64-run
cat > /etc/profile.d/cirrascale.sh << 'EOF'
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

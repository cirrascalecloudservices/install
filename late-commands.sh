#!/bin/sh -eux

# usage: sh <(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/main/late-commands.sh)
# cirrascale: ['curtin', 'in-target', '--', 'sh', '-c', 'sh <(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/main/late-commands.sh)']

. /etc/os-release

# https://launchpad.net/ubuntu/+source/cloud-init

if [ "$UBUNTU_CODENAME" = "focal" ]; then
	apt-get install --allow-downgrades cloud-init=23.1.2-0ubuntu0~20.04.2 -y
fi

if [ "$UBUNTU_CODENAME" = "jammy" ]; then
	apt-get install --allow-downgrades cloud-init=23.1.2-0ubuntu0~22.04.1 -y
fi

if [ "$UBUNTU_CODENAME" = "noble" ]; then
	apt-get install --allow-downgrades cloud-init=24.1.3-0ubuntu3 -y
fi

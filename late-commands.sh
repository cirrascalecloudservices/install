#!/bin/sh -eux

# usage: sh -c "$(curl -s https://raw.githubusercontent.com/cirrascalecloudservices/install/main/late-commands.sh)"

. /etc/os-release

systemctl set-default multi-user.target

echo GRUB_TIMEOUT=5 > /etc/default/grub.d/99-cirrascale.cfg
echo GRUB_TIMEOUT_STYLE=menu >> /etc/default/grub.d/99-cirrascale.cfg
update-grub

ln -s /usr/share/unattended-upgrades/20auto-upgrades-disabled /etc/apt/apt.conf.d || true

# https://launchpad.net/ubuntu/+source/cloud-init
if [ "$UBUNTU_CODENAME" = "focal" ]; then
#	apt-get install --allow-downgrades cloud-init=23.1.2-0ubuntu0~20.04.2 -y
fi
if [ "$UBUNTU_CODENAME" = "jammy" ]; then
#	apt-get install --allow-downgrades cloud-init=23.1.2-0ubuntu0~22.04.1 -y
fi
if [ "$UBUNTU_CODENAME" = "noble" ]; then
	echo > /etc/apt/sources.list # https://discourse.maas.io/t/repositories-are-configured-multiple-times/10855
#	apt-get install --allow-downgrades cloud-init=24.1.3-0ubuntu3 -y
fi

#!/bin/sh -x

systemctl set-default multi-user.target

echo 'cirrascale ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/cirrascale

(cd /etc/profile.d && wget https://raw.githubusercontent.com/cirrascalecloudservices/install/main/etc/profile.d/cirrascale.sh)

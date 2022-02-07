#!/bin/sh -x

systemctl set-default multi-user.target

echo 'cirrascale ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/cirrascale

# install nvidia cuda
#sh -c "$(curl -sL https://raw.githubusercontent.com/cirrascalecloudservices/install/main/install-nvidia-cuda-11.5-495.sh)"
(cd /etc/profile.d && wget https://raw.githubusercontent.com/cirrascalecloudservices/install/main/etc/profile.d/cirrascale.sh)

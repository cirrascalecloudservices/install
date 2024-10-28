#!/bin/bash -eux
set -o pipefail
shopt -s inherit_errexit || true
sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=15/g' /etc/default/grub
sed -i 's/GRUB_TIMEOUT_STYLE=.*/# GRUB_TIMEOUT_STYLE=hidden/g' /etc/default/grub

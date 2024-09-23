#!/bin/bash -eux
set -o pipefail
shopt -s inherit_errexit || true
sed -i 's/GRUB_TIMEOUT=0/GRUB_TIMEOUT=15/' /etc/default/grub
sed -i 's/GRUB_TIMEOUT_STYLE=hidden/# GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub

#!/bin/bash
set -x

# Update & Install packages
apt-get update -qq
apt-get upgrade -qy
apt-get install -qy --no-install-recommends \
    vim \
    git \
    wget \
    curl \
    unzip \
    cloud-init \
    ssh-import-id \
    screen
apt-get autoremove -y

cloud-init init --local

# Link cloud-init config to VFAT /boot partition
mkdir -p /var/lib/cloud/seed/nocloud-net
ln -s /boot/user-data /var/lib/cloud/seed/nocloud-net/user-data
ln -s /boot/meta-data /var/lib/cloud/seed/nocloud-net/meta-data
ln -s /boot/network-config /var/lib/cloud/seed/nocloud-net/network-config

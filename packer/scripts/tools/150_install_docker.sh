#!/usr/bin/env bash

set -e

# You can run & build x86 image over arm :
# https://ownyourbits.com/2018/06/27/running-and-building-arm-docker-containers-in-x86/
# https://www.stereolabs.com/docs/docker/building-arm-container-on-x86/

apt-get update
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    qemu-system binfmt-support -y

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg


arch=${ARCH}

if [[ ${ARCH} == "aarch64" ]]; then
	arch=arm64
fi

echo "==> arch: ${arch} / ${ARCH}"

echo \
  "deb [arch=${arch} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce containerd.io -y

# usermod -aG docker ${SYSTEM_USER}

apt-get clean && rm -rf /var/lib/apt/lists/*

systemctl enable docker.service
systemctl enable containerd.service

#!/bin/bash

set -o errtrace -o nounset -o pipefail -o errexit

echo "==> Installing dependencies"
apt-get update -y
apt-get install -y apt-transport-https ca-certificates gnupg lsb-release

echo "==> Installing Docker"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "==> Cleaning"
apt-get clean
rm -rf /var/lib/apt/lists/*

#!/usr/bin/env bash

set -e

apt-get update --allow-releaseinfo-change
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get autoremove -y

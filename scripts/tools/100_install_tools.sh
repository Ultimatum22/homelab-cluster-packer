#!/usr/bin/env bash

set -e

if [[ ${var.install_tools} != "" ]]; then
    apt-get update && apt-get install -y ${var.install_tools} \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
fi
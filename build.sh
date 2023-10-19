#!/bin/bash

[ -d logs ] || mkdir logs
[ -d output ] || mkdir output

echo "Initializing packer"
packer init templates/rpi

echo "Build it"
docker run --rm --privileged \
    -v /dev:/dev \
    -v ${PWD}:/build \
    mkaczanowski/packer-builder-arm build \
    -var "git_repo=$(git remote get-url origin)" \
    -var "git_commit=$(git rev-parse HEAD)" \
    -var-file=templates/pkrvars.hcl \
    templates/rpi | tee logs/rpi_output.txt
# docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build -var-file=pkrvars.hcl -var "git_repo=$(git remote get-url origin)" -var "git_commit=$(git rev-parse HEAD)" pi.pkr.hcl
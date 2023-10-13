# Packer

## Run

docker run --rm --privileged \
    -v /dev:/dev \
    -v ${PWD}:/build \
    mkaczanowski/packer-builder-arm \
        build \
        -var-file=pkrvars.hcl \
        -var "git_repo=$(git remote get-url origin)" \
        -var "git_commit=$(git rev-parse HEAD)" \
        pi.pkr.hcl

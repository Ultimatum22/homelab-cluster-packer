# Packer

## Run

docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm build -var-file=templates/pi3/variables.auto.pkrvars.hcl -var-file=pkrvars.hcl -var "git_repo=$(git remote get-url origin)" -var "git_commit=$(git rev-parse HEAD)" templates/pi3/

## Set password user

`echo <password> | mkpasswd -m sha-512 -s`

## docs

https://git.iamthefij.com/iamthefij/homelab-nomad
https://github.com/Elara6331/nomad
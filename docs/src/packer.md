# Packer

To create iso images for the rapsberry pi Packer is used. Because arm is not default supported by Packer. To easy use we used a docker image provider by the plugin. To initialise the project use the following project.

`docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build \
    mkaczanowski/packer-builder-arm init`

YOu can use the `make build` command, which uses the following docker command.

`docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build \
    mkaczanowski/packer-builder-arm build \
    -var "git_repo=$(git remote get-url origin)" \
    -var "git_commit=$(git rev-parse HEAD)" \
    -var-file packer/boards/$(hostname).pkrvars.hcl \
    packer/boards/raspios_lite | tee $(LOGS_DIR)/rpi_output.txt`

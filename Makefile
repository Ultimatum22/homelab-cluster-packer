all: docker build

clean:
	rm -f output/*.img

docker:
	docker pull mkaczanowski/packer-builder-arm

build: docker clean
	docker run \
		--rm \
		--privileged \
		-v /dev:/dev \
		-v ${PWD}:/build \
		mkaczanowski/packer-builder-arm build \
		-var "git_repo=$(git remote get-url origin)" \
		-var "git_commit=$(git rev-parse HEAD)" \
		-var-file templates/pkrvars.hcl \
		templates/rpi | tee logs/rpi_output.txt

flash:
	flash --force \
		--userdata ./files/boot/user-data.yaml \
		./output/rpi-cloud-init-raspios-bullseye-armhf.img
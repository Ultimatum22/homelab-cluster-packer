# Define variables for paths
OUTPUT_DIR := output
LOGS_DIR := logs
TEMPLATES_DIR := templates
ARCH := armhf
ARCH_QEMU := arm64

.PHONY: all clean docker unmount build dd

all: docker build

clean:
	rm -f $(IMG_FILE)

docker:
	docker pull mkaczanowski/packer-builder-arm

unmount:
	-umount -lq /media/dave/bootfs
	-umount -lq /media/dave/rootfs

dd: unmount
	@if [ -z "$(hostname)" ]; then \
		echo "Error: 'hostname' argument is required."; \
		exit 1; \
	fi
	@if [ -z "$(of)" ]; then \
		echo "Error: 'of' argument is required."; \
		exit 1; \
	fi
	sudo dd if=$(OUTPUT_DIR)/raspios_$(hostname)-armhf.img of=$(of) bs=4M status=progress

build: docker clean
	@if [ -z "$(hostname)" ]; then \
		echo "Error: 'hostname' argument is required."; \
		exit 1; \
	fi
	docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build \
		mkaczanowski/packer-builder-arm build \
		-var "git_repo=$(git remote get-url origin)" \
		-var "git_commit=$(git rev-parse HEAD)" \
		-var-file boards/$(hostname).pkrvars.hcl \
		boards/raspios_lite | tee $(LOGS_DIR)/rpi_output.txt

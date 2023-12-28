# Define variables for paths
OUTPUT_DIR := output
LOGS_DIR := logs
TEMPLATES_DIR := templates
ARCH := armhf
ARCH_QEMU := arm64
SHELL := /bin/bash

PACKER_DOCKER_RUN = docker run --rm --privileged -v /dev:/dev -v ${PWD}:/build packer-builder-arm:latest
PACKER_VARS = -var-file=packer/armhf/auto.pkrvars.hcl
PACKER_BOARD_DIR = packer/armhf/

.PHONY: all clean docker unmount build dd venv pre-commit docs

# Development

install: pipenv pre-commit.install apt.install ansible.install

apt.install:
	apt-get install parted

pipenv:
	pipenv install --dev
	pipenv shell

pipenv.install: pipenv.venv
	pip install --user --upgrade pipenv pip
	pip --version
	pipenv --version

pipenv.venv:
	rm -rf .venv
	mkdir -p .venv

pre-commit.install:
	pre-commit install

pre-commit:
	pre-commit run --all-files

# Docs
docs:
	mdbook serve docs --open

# Packer
packer.build:
	$(PACKER_DOCKER_RUN) build $(PACKER_VARS) $(PACKER_BOARD_DIR)

packer.validate:
	$(PACKER_DOCKER_RUN) validate $(PACKER_VARS) $(PACKER_BOARD_DIR)

packer.init:
	$(PACKER_DOCKER_RUN) init $(PACKER_VARS) $(PACKER_BOARD_DIR)

# Ansible
ansible.install:
	cd ansible && ansible-galaxy install -r requirements.yml

ansible.bootstrap:
	cd ansible && ansible-playbook playbooks/bootstrap.yml

ansible.cluster:
	cd ansible && ansible-playbook playbooks/cluster.yml

ansible.vault-init-unseal:
	cd ansible && ansible-playbook playbooks/vault-init-unseal.yml

# Vagrant
vagrant.up:
	cd vagrant && vagrant up

vagrant.provision:
	cd vagrant && vagrant provision

vagrant.destroy:
	cd vagrant && vagrant destroy -f

vars.generate: pipenv
	python bin/generate-vars.py






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
		-var-file packer/boards/$(hostname).pkrvars.hcl \
		packer/boards/raspios_lite | tee $(LOGS_DIR)/rpi_output.txt

packer {
  required_plugins {

    arm = {
      source = "github.com/cdecoux/builder-arm"
      version = "1.0.0"
    }

    ansible = {
      version = "v1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  vm_name        = "${var.vm_name}-${formatdate("YYYY-MM-DD", timestamp())}"
  ssh_public_key = file(var.ssh_public_key_path)
  template_desc  = "${var.template_description}. Created by Packer on ${formatdate("YYYY-MM-DD", timestamp())}."
  ipv4           = "${var.ip_address}/24"


  preseed = {
    username      = var.ssh_username
    password      = var.ssh_password
    root_password = var.root_password
  }
}

source "arm" "raspios" {

  file_checksum_type = "sha256"
  file_checksum_url  = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz.sha256"

  file_target_extension = "xz"
  file_urls             = ["https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz"]
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]

  image_build_method = "resize"

  image_chroot_env = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]

  image_partitions {
    filesystem   = "vfat"
    mountpoint   = "/boot"
    name         = "boot"
    size         = "256M"
    start_sector = "8192"
    type         = "c"
  }

  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "532480"
    type         = "83"
  }

  image_path                   = "./builds/armhf.img"
  image_size                   = "4.5G"
  image_type                   = "dos"
  qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
  qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

build {
  sources = ["source.arm.raspios"]

  provisioner "shell" {
    inline = [
      "echo Username : ${var.ssh_username}",
      # useradd -m -s /usr/bin/bash -U -G users ${SYSTEM_USER}
      "useradd -m -s /usr/bin/bash ${var.ssh_username}",
      # "echo ${var.ssh_username}:${var.ssh_password} | chpasswd",
      "sudo userdel -r -f pi"
    ]
  }

  # make user ssh-ready for Ansible
  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    inline = [
      "HOME_DIR=/home/${var.ssh_username}/.ssh",
      "mkdir -m 0700 -p $HOME_DIR",
      "echo '${local.ssh_public_key}' >> $HOME_DIR/authorized_keys",
      "chown -R ${var.ssh_username}:${var.ssh_username} $HOME_DIR",
      "chmod 0600 $HOME_DIR/authorized_keys",
      "SUDOERS_FILE=/etc/sudoers.d/80-packer-users",
      "echo '${var.ssh_username} ALL=(ALL) NOPASSWD: ALL' > $SUDOERS_FILE",
      "chmod 0440 $SUDOERS_FILE",
    ]
  }

  # # inventory file is automatically generated by Packer
  provisioner "ansible" {
    playbook_file = "./ansible/playbooks/common.yml"
  }

  # inventory file is automatically generated by Packer
  provisioner "ansible" {
    playbook_file = "./ansible/playbooks/common.yml"
    extra_arguments = [
      "--extra-vars",
      "user=${var.ssh_username}",
    ]
    user        = var.ssh_username
    galaxy_file = "./ansible/requirements.yml"
  }
}

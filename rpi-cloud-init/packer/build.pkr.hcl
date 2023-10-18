
build {
  sources = [
    "source.arm-image.raspios_bullseye_armhf",
    "source.arm-image.raspios_bullseye_arm64"
  ]

  # Add kernel modules to load
  provisioner "shell" {
      inline = [
        "sudo apt-get install cloud-init -y",
        "sudo cloud-init init --local",
        "sudo cloud-init init"
      ]
  }

  # cloud-init cloud.cfg
  provisioner "file" {
      source = "cloud-init/cloud.cfg.yaml"
      destination = "/etc/cloud/cloud.cfg"
  }

  # Copy meta-data and user-data (NoCloud with local paths)
  # https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html
  provisioner "file" {
      source = "cloud-init/meta-data.yaml"
      destination = "/boot/meta-data"
  }

  provisioner "file" {
      source = "cloud-init/user-data.yaml"
      destination = "/boot/user-data"
  }

    # Enable services
  provisioner "shell" {
      inline = [
          "sudo systemctl enable ssh",
          "sudo systemctl enable cloud-init"
      ]
  }
}

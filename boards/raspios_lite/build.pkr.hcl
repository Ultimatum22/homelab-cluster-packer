
build {
  sources = [
    "source.arm.raspios",
    # "source.arm.raspios_bookworm_arm64"
  ]

  # Enable ssh
  provisioner "shell" {
    inline = [
      "touch /boot/ssh",
    ]
  }
  # Set dns
  provisioner "shell" {
    inline = [
      "mv /etc/resolv.conf /etc/resolv.conf.bk",
      "echo 'nameserver 1.1.1.1' > /etc/resolv.conf",
      "echo 'nameserver 1.0.0.1' >> /etc/resolv.conf",
    ]
  }

  # Backup original /boot files
  provisioner "shell" {
    inline = [
      "cp /boot/config.txt /boot/config.txt.bak",
      "cp /boot/cmdline.txt /boot/cmdline.txt.bak",
    ]
  }

  provisioner "file" {
    destination = "/tmp"
    source      = "scripts/tools"
  }

  provisioner "shell" {
    script = "scripts/bootstrap.sh"
  }
}

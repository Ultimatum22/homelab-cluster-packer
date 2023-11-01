
build {
  sources = [
    "source.arm.raspios",
    # "source.arm.raspios_bookworm_arm64"
  ]
  
  # # Set dns
  # provisioner "shell" {
  #   inline = [
  #     "mv /etc/resolv.conf /etc/resolv.conf.bk",
  #     "echo 'nameserver 1.1.1.1' > /etc/resolv.conf",
  #     "echo 'nameserver 1.0.0.1' >> /etc/resolv.conf",
  #   ]
  # }

  # # Backup original /boot files
  # provisioner "shell" {
  #   inline = [
  #     "cp /boot/config.txt /boot/config.txt.bak",
  #     "cp /boot/cmdline.txt /boot/cmdline.txt.bak",
  #   ]
  # }

  provisioner "file" {
    destination = "/tmp"
    source      = "scripts/tools"
  }

  provisioner "shell" {
    environment_vars = [
        "HOSTNAME=${var.hostname}",
        "SYSTEM_USER=${var.system_user}",
        "SYSTEM_USER_PASSWORD=${var.system_user_password}",
        "INSTALL_TOOLS=${var.install_tools}",
        "ARCH=${var.arch}",
        "CLUSTER_IPS=(${var.cluster_ips})",
        "KEYBOARD=${var.keyboard}",
        "TIMEZONE=${var.timezone}",
        "CONSUL_ENCRYPTION_KEY=${var.consul_encryption_key}",
        "CONSUL_CERTIFICATE_ID=${var.consul_certificate_id}"
    ]
    script = "scripts/bootstrap.sh"
  }

  provisioner "file" {
    destination = "//etc/consul.d/"
    source      = "files/homelab-client-consul-${var.consul_certificate_id}.pem"
  }

  provisioner "file" {
    destination = "/etc/consul.d/"
    source      = "files/homelab-client-consul-${var.consul_certificate_id}-key.pem"
  }

  provisioner "file" {
    destination = "/etc/consul.d/"
    source      = "files/consul-agent-ca.pem"
  }
}

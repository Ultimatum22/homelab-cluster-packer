
build {
    sources = [
        "source.arm.raspios_bookworm_armhf"
        "source.arm.raspios_bookworm_arm64"
    ]
    # Backup original /boot files
    provisioner "shell" {
        inline = [
           "cp /boot/config.txt /boot/config.txt.bak",
           "cp /boot/cmdline.txt /boot/cmdline.txt.bak",
        ]
    }

    # Generate new /boot/config.txt
    provisioner "shell" {
        inline = [
        <<-EOF
			tee /boot/config.txt <<- CONFIG
				# (generated $(date))
				# ${var.git_repo} (${var.git_commit})

				${local.boot_config}
				CONFIG
        EOF
        ]
    }

    # Generate new /boot/cmdline.txt
    provisioner "shell" {
        inline = [
        <<-EOF
			tee /boot/cmdline.txt <<- CONFIG
				${local.boot_cmdline}
				CONFIG
        EOF
        ]
    }

    # Add locales that will get generated on first boot
    provisioner "shell" {
        inline = [
        <<-EOF
			tee -a /etc/locale.gen <<- CONFIG
				${local.localgen}
				CONFIG
        EOF
        ]
    }

    # Set dns
    provisioner "shell" {
        inline = [
            "rm -f /etc/resolv.conf",
            "echo 'nameserver 1.1.1.1' > /etc/resolv.conf",
            "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf",
        ]
    }

    # Update, upgrade and autoremove packages
    provisioner "shell" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get upgrade -y",
            "sudo apt-get autoremove -y",
            "sudo apt-get clean -y"
        ]
    }
    
    provisioner "file" {
        source = "scripts/resizerootfs"
        destination = "/tmp"
    }

    provisioner "shell" {
        script = "./scripts/bootstrap_resizerootfs.sh"
    }

    provisioner "shell" {
        script = "./scripts/install_docker_apt.sh"
    }

    provisioner "shell" {
        script = "./scripts/manage_users.sh"
    }

    # Set locale
    provisioner "shell" {
        inline = [
            "echo 'LC_CTYPE=\"en_US.UTF-8\"' >> /etc/default/locale",
            "echo 'LC_ALL=\"en_US.UTF-8\"' >> /etc/default/locale",
            "echo 'LANG=\"en_US.UTF-8\"' >> /etc/default/locale",
            "DEBIAN_FRONTEND=noninteractive apt-get install keyboard-configuration"
        ]
    }
}

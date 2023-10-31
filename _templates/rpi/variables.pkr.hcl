variable "image_date_version" {
    type = string
    description = <<-EOT
        The date of the image.
    EOT
}

# Variables: OS Config

variable "locales" {
    type = list(string)
    description = "List of locales to generate, as seen in `/etc/locale.gen`."
    default = ["en_GB.UTF-8 UTF-8", "en_US.UTF-8 UTF-8"]
}

# Variables: /boot configs

variable "boot_cmdline" {
    type = list(string)
    description = <<-EOT
        [`/boot/cmdline.txt`](https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md) config.
        
        Linux kernel boot parameters, as a list. Will be joined as a space-delimited string.

        e.g.:
        ```
        boot_cmdline = [
            "abc",
            "def"
        ]
        ```
        Will create `/boot/cmdline.txt` as
        ```
        abc def
        ```
    EOT
    default = [
        "console=serial0,115200",
        "console=tty1",
        "root=/dev/mmcblk0p2", # multimedia (SD) card block 0 partition 2
        "rootfstype=ext4",
        "elevator=deadline",
        "fsck.repair=yes",
        "rootwait",
        "quiet",
        "init=/usr/lib/raspi-config/init_resize.sh"
    ]
}

variable "boot_config" {
    type = list(string)
    description = <<-EOT
        [`/boot/config.txt`](https://www.raspberrypi.org/documentation/configuration/config-txt/README.md)

        Raspberry Pi system configuration, as a list. Will be joined by newlines.

        e.g.:
        ```
        boot_cmdline = [
            "abc=123",
            "def=456"
        ]
        ```
        Will begin `/boot/config.txt` with:
        ```
        abc=123
        def=456
        ```
    EOT
    default = []
}

variable "boot_config_filters" {
    type = list(list(string))
    description = <<-EOT
        [`/boot/config.txt`](ttps://www.raspberrypi.org/documentation/configuration/config-txt/conditional.md)

        Raspberry Pi system *conditional filters* configuration, as a list.

        e.g.:
        ```
        boot_config_filters = [
            [
                "[pi0]",
                "jhi=123",
                "klm=456"
            ],
            [
                "[pi0w]",
                "xzy",
                "123"
            ],
        ]
        ```
        Will end `/boot/config.txt` with:
        ```
        [pi0]
        jhi=123
        klm=456
        [pi0w]
        xyz
        123
        ```
    EOT
    default = [
        [
			"[pi4]",
            "dtoverlay=vc4-fkms-v3d",
            "max_framebuffers=2"
        ]
	]
}

variable "cloudinit_metadata_file" {
    type = string
    description = <<-EOT
        The local path to a cloud-init metadata file.
        
        See the `cloud-init` [`NoCloud` datasource](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)
    EOT
}

variable "cloudinit_userdata_file" {
    type = string
    description = <<-EOT
        The local path to a cloud-init userdata file.
        
        See the `cloud-init` [`NoCloud` datasource](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)
    EOT
}

variable "kernel_modules" {
    type = list(string)
    description = "List of Linux kernel modules to enable, as seen in `/etc/modules`"
    default = []
}

variable "git_repo" {
    type = string
    description = <<-EOT
        The current git remote to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_repo=$(git remote get-url origin)" `
    EOT
    default = ""
}

variable "git_commit" {
    type = string
    description = <<-EOT
        The current git commit to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_commit=$(git rev-parse HEAD)"`
    EOT
    default = ""
}

variable "system_user" {
  type        = string
}

variable "system_user_password" {
  type        = string
}

variable "install_tools" {
  type        = list(string)
}

locals {
    # Generate files string content

    # /boot/cmdline.txt
    boot_cmdline = join(" ", var.boot_cmdline)

    # /boot/config.txt
    boot_config = <<-EOF
# General config
%{ for config in var.boot_config ~}
${~ config}
%{ endfor ~}

# Filtered config
%{ for filter_block in var.boot_config_filters ~}
%{ for filter_element in filter_block ~}
${~ filter_element }
%{ endfor ~}
%{ endfor ~}
EOF

    # /etc/locale.gen
    localgen = join("\n", var.locales)

    # /etc/modules
    kernel_modules = join("\n", var.kernel_modules)
}
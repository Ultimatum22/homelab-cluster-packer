variable "file_url" {
    type = string
    description = <<-EOT
        The URL of the OS image file.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
}

variable "file_target_extension" {
    type = string
    description = <<-EOT
        The file extension of `file_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = "zip"
}

variable "file_unarchive_cmd" {
    type = list(string)
    description = <<-EOT
        The file extension of `file_unarchive_cmd`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = []
}

variable "file_checksum" {
    type = string
    description = <<-EOT
        The checksum value of `file_url`.

        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = ""
}


variable "file_checksum_url" {
    type = string
    description = <<-EOT
        The checksum file URL of `file_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = ""
}

variable "file_checksum_type" {
    type = string
    description = <<-EOT
        The checksum type of `file_checksum_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = "sha256"
}

# Variables: packer-builder-arm builder 'image_'
# https://github.com/mkaczanowski/packer-builder-arm#image-config

variable "image_path" {
    type = string
    description = "The file path the new OS image to create."
}

# Variables: OS Config

variable "locales" {
    type = list(string)
    description = "List of locales to generate, as seen in `/etc/locale.gen`."
    default = ["en_CA.UTF-8 UTF-8", "en_US.UTF-8 UTF-8"]
}

# Variables: /boot configs

variable "wpa_supplicant_enabled" {
    type = bool
    description = <<-EOT
        Create a [`wpa_supplicant.conf` file](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md) on the image.
        
        If `wpa_supplicant_path` exists, it will be copied to the OS image, otherwise a basic `wpa_supplicant.conf` file will be created using `wpa_supplicant_ssid`, `wpa_supplicant_pass` and `wpa_supplicant_country`.
    EOT
    default = true
}

variable "wpa_supplicant_path" {
    type = string
    description = "The local path to existing `wpa_supplicant.conf` to copy to the image."
    default = "/tmp/dummy" # fileexists() doesn't like empty strings
}

variable "wpa_supplicant_ssid" {
    type = string
    description = "The WiFi SSID."
    default = ""
}

variable "wpa_supplicant_pass" {
    type = string
    description = "The WiFi password."
    default = ""
}

variable "wpa_supplicant_country" {
    type = string
    description = <<-EOT
        The [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code in which the device is operating.
        
        Required by the wpa_supplicant.
    EOT
    default = "CA"
}

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

# variable "cloudinit_metadata_file" {
#     type = string
#     description = <<-EOT
#         The local path to a cloud-init metadata file.
        
#         See the `cloud-init` [`NoCloud` datasource](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)
#     EOT
# }

# variable "cloudinit_userdata_file" {
#     type = string
#     description = <<-EOT
#         The local path to a cloud-init userdata file.
        
#         See the `cloud-init` [`NoCloud` datasource](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)
#     EOT
# }

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
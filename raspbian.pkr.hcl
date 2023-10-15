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
    default = ["en_GB.UTF-8 UTF-8", "en_US.UTF-8 UTF-8"]
}

source "arm" "rpi" {
    file_checksum_url     = var.file_checksum_url
    file_checksum_type    = var.file_checksum_type

    file_target_extension = var.file_target_extension
    file_unarchive_cmd    = var.file_unarchive_cmd
    file_urls             = [var.file_url]

    image_build_method    = "resize"

    image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
    
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

    image_path                   = var.image_path
    image_size                   = "4G"
    image_type                   = "dos"
    qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
    qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

build {
    sources = ["source.arm.rpi"]

    provisioner "shell" {
        script = "provision-raspberry.sh"
    }

}

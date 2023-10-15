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
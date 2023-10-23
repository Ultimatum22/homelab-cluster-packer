source "arm" "raspios" {

    file_checksum_type    = "sha256"
    file_checksum_url     = "https://downloads.raspberrypi.com/raspios_lite_${var.arch}/images/raspios_lite_${var.arch}-${var.image_version}/${var.image_file}-${var.arch}-lite.img.xz.sha256"

    file_target_extension = "xz"
    file_urls             = ["https://downloads.raspberrypi.com/raspios_lite_${var.arch}/images/raspios_lite_${var.arch}-${var.image_version}/${var.image_file}-${var.arch}-lite.img.xz"]
    file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]

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

    image_path                   = "output/${var.image_output}-${var.arch}.img"
    image_size                   = "${var.image_size}G"
    image_type                   = "${var.image_type}"
    qemu_binary_destination_path = "/usr/bin/qemu-${var.arch_qemu}-static"
    qemu_binary_source_path      = "/usr/bin/qemu-${var.arch_qemu}-static"
}
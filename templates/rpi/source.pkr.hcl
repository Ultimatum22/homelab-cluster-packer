source "arm" "raspios_bookworm_armhf" {

    file_checksum_type    = "sha256"
    file_checksum_url     = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz.sha256"

    file_target_extension = "xz"
    file_urls             = ["https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz"]
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

    image_path                   = "output/rpi-cloud-init-raspios-bullseye-armhf.img"
    image_size                   = "4G"
    image_type                   = "dos"
    qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
    qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

source "arm" "raspios_bookworm_arm64" {
    file_checksum_type    = "sha256"
    file_checksum_url     = "https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz.sha256"

    file_target_extension = "xz"
    file_urls             = ["https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz"]
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

    image_path                   = "output/rpi-cloud-init-raspios-bullseye-arm64.img"
    image_size                   = "4G"
    image_type                   = "dos"
    qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
    qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}
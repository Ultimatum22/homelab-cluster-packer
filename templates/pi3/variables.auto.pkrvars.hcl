file_checksum_type    = "sha256"
file_checksum_url     = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz.sha256"

file_target_extension = "xz"
file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
file_url              = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz"

image_path = "output/pi3.img"
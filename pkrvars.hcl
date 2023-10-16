# Raspberry Pi OS base image
# https://github.com/mkaczanowski/packer-builder-arm#remote-file

file_url              = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf-lite.zip"
file_target_extension = "zip"

file_checksum_url  = "https://downloads.raspberrypi.com/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/2021-10-30-raspios-bullseye-armhf-lite.zip.sha256"
file_checksum_type = "sha256"
// file_unarchive_cmd  = ["xz", "-d", "$ARCHIVE_PATH"]

# Resulting image file
# Could also be passed at the command line, e.g.
# -var="image_path=whatever.img"

image_path = "output/rpi.img"

# wpa_supplicant.conf file to use
# https://linux.die.net/man/5/wpa_supplicant.conf

wpa_supplicant_enabled = false
# wpa_supplicant_path = ""
# wpa_supplicant_ssid = ""
# wpa_supplicant_pass = ""
# wpa_supplicant_country = ""

# /boot/cmdline.txt (default)
# https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md

boot_cmdline = [
    "console=serial0,115200",
    "console=tty1",
    "root=PARTUUID=9730496b-02",
    "rootfstype=ext4",
    "fsck.repair=yes",
    "rootwait",
    "quiet"
]

# /boot/config.txt (properties) (default)
# http://rpf.io/configtxt
# https://elinux.org/RPiconfig

boot_config = [
        "dtoverlay=vc4-fkms-v3d",
        "max_framebuffers=2"
    ]

# /boot/config.txt (conditional filters properties) (default)
# https://www.raspberrypi.org/documentation/configuration/config-txt/conditional.md

boot_config_filters = [
    [
    ]
]

# Kernel modules to load at boot time

kernel_modules = []

# cloud-init (NoCloud with local paths)
# https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html

cloudinit_metadata_file = "cloud-init/meta-data.yaml"
cloudinit_userdata_file = "cloud-init/user-data.yaml"
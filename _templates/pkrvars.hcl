boot_cmdline = [
    "console=serial0,115200",
    "console=tty1",
    "root=PARTUUID=7550d926-02",
    "rootfstype=ext4",
    "fsck.repair=yes",
    "rootwait",
    "quiet",
    "init=/usr/lib/raspberrypi-sys-mods/firstboot"
]

cloudinit_metadata_file = "cloud-init/meta-data.yaml"
cloudinit_userdata_file = "cloud-init/user-data.yaml"
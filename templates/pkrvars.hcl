boot_cmdline = [
    "console=serial0,115200",
    "console=tty1",
    "root=PARTUUID=9730496b-02",
    "rootfstype=ext4",
    "fsck.repair=yes",
    "rootwait",
    "quiet",
    "init=/usr/lib/raspi-config/init_resize.sh"
]
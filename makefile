# Makefile

# Directory to mount
ROOT_FS := /media/dave/rootfs
BOOT_FS := /media/dave/boot

# Source and destination for the dd command
SOURCE := /dev/sdc
DESTINATION := rpi.img

# Default target
all: build

# Target to unmount the directory (if it exists)
unmount:
    @if mountpoint -q $(MOUNT_DIR); then \
        echo "Unmounting $(MOUNT_DIR)..."; \
        umount $(MOUNT_DIR); \
    else \
        echo "$(MOUNT_DIR) is not mounted."; \
    fi

# Target to copy data using the dd command
copy:
    @echo "Copying data from $(SOURCE) to $(DESTINATION) using dd..."
    dd if=$(SOURCE) of=$(DESTINATION) bs=4M

.PHONY: unmount copy

# Usage: make build
#        make unmount
#        make copy

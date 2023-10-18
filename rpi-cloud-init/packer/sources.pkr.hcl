source "arm-image" "raspios_bullseye_armhf" {
  image_type      = "raspberrypi"
  iso_url         = "http://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2023-10-10/2023-10-10-raspios-bookworm-armhf-lite.img.xz"
  iso_checksum    = "sha256:1f8a646b375b198ef9f48c940889ac9f61744d1c1105b36c578313edbc81a339"
  output_filename = "images/rpi-cloud-init-raspios-bullseye-armhf.img"
  qemu_binary     = "qemu-aarch64-static"
}

source "arm-image" "raspios_bullseye_arm64" {
  image_type      = "raspberrypi"
  iso_url         = "http://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz"
  iso_checksum    = "sha256:26ef887212da53d31422b7e7ae3dbc3e21d09f996e69cbb44cc2edf9e8c3a5c9"
  output_filename = "images/rpi-cloud-init-raspios-bullseye-arm64.img"
  qemu_binary     = "qemu-aarch64-static"
}
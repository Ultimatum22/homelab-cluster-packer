variable "image_version" {
  type        = string
  description = <<-EOT
        The date of the image.
    EOT
}
variable "image_file" {
  type        = string
  description = <<-EOT
        Full image file with date

        e.g.:
        ```
        2023-10-10-raspios-bookworm
        ```
    EOT
}
variable "image_output" {
  type = string
}

variable "image_size" {
  type = string
  description = <<-EOT
        Defined in gigabytes
    EOT
}

variable "image_type" {
  type = string

  validation {
    condition     = var.image_type == "dos"
    error_message = "Valid value for 'image_type' is 'dos'."
  }
}

variable "arch" {
  type = string

  validation {
    condition     = can(regex("^armhf$|^arm64$", var.arch))
    error_message = "Valid values for 'arch' are 'armhf' or 'arm64'."
  }
}

variable "arch_qemu" {
  type = string

  validation {
    condition     = can(regex("^armhf$|^arm64$", var.arch_qemu))
    error_message = "Valid values for 'arch' are 'armhf' or 'arm64'."
  }
}
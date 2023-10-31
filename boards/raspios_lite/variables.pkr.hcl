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
  type        = string
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

variable "hostname" {
  type = string
}

variable "git_repo" {
  type        = string
  description = <<-EOT
        The current git remote to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_repo=$(git remote get-url origin)" `
    EOT
  default     = ""
}

variable "git_commit" {
  type        = string
  description = <<-EOT
        The current git commit to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_commit=$(git rev-parse HEAD)"`
    EOT
  default     = ""
}

variable "system_user" {
  type = string
}

variable "system_user_password" {
  type = string
}

variable "install_tools" {
  type = string
}

variable "cluster_ips" {
  type = string
  description = <<-EOT
        Space based list, this is because of restrictions of packer to pass a list of strings in environment_vars
    EOT
}

variable "keyboard" {
  type = string
}

variable "timezone" {
  type = string
}

# variable "public_ssh_keys" {
#   type = string
#   description = <<-EOT
#         Space based list, this is because of restrictions of packer to pass a list of strings in environment_vars
#     EOT
#   default     = ""
# }

variable "omad_"
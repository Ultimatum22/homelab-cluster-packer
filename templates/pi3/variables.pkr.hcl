variable "file_url" {
    type = string
    description = <<-EOT
        The URL of the OS image file.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
}

variable "file_target_extension" {
    type = string
    description = <<-EOT
        The file extension of `file_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = "zip"
}

variable "file_unarchive_cmd" {
    type = list(string)
    description = <<-EOT
        The file extension of `file_unarchive_cmd`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = []
}

variable "file_checksum" {
    type = string
    description = <<-EOT
        The checksum value of `file_url`.

        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = ""
}


variable "file_checksum_url" {
    type = string
    description = <<-EOT
        The checksum file URL of `file_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = ""
}

variable "file_checksum_type" {
    type = string
    description = <<-EOT
        The checksum type of `file_checksum_url`.
        
        See [packer-builder-arm](https://github.com/mkaczanowski/packer-builder-arm#remote-file).
    EOT
    default = "sha256"
}

# Variables: packer-builder-arm builder 'image_'
# https://github.com/mkaczanowski/packer-builder-arm#image-config

variable "image_path" {
    type = string
    description = "The file path the new OS image to create."
}

variable "git_repo" {
    type = string
    description = <<-EOT
        The current git remote to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_repo=$(git remote get-url origin)" `
    EOT
    default = ""
}

variable "git_commit" {
    type = string
    description = <<-EOT
        The current git commit to pass to the build. It will be prepended to `/boot/config.txt`

        Use on the command-line, i.e. `-var "git_commit=$(git rev-parse HEAD)"`
    EOT
    default = ""
}

# Variables: OS Config

variable "locales" {
    type = list(string)
    description = "List of locales to generate, as seen in `/etc/locale.gen`."
    default = ["en_GB.UTF-8 UTF-8", "en_US.UTF-8 UTF-8"]
}

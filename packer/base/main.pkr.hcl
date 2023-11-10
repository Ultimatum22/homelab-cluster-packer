packer {
  required_plugins {
    ansible = {
      version = "v1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  preseed = {
    username      = var.ssh_username
    password      = var.ssh_password
    root_password = var.root_password
  }
  ssh_public_key = file(var.ssh_public_key_path)
}

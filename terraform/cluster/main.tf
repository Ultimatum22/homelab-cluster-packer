locals {
  ssh_timeout   = "10s"
  default_sleep = "1s"

  connectionpw = {
    type     = "ssh"
    host     = var.ip_adress
    user     = var.initial_user
    password = var.initial_password
    timeout  = local.ssh_timeout
  }

  connectionkey = {
    type     = "ssh"
    host     = var.ip_adress
    user     = var.initial_user
    public_key = var.ssh_public_key
    timeout  = local.ssh_timeout
  }
}


module "authorized_keys" {
  source = "./modules/authorized_keys"
  connection = local.connectionpw

  ssh_public_key = var.ssh_public_key
}

module "apt_upgrade" {
  source = "./modules/apt_upgrade"
  connection = local.connectionkey

  depends = [
    module.authorized_keys,
  ]
}

// module "apt_install" {
//   source = "./modules/apt_install"
//   connection = local.connectionkey

//   install = "ncdu htop nano mc iotop"

//   depends = [
//     module.authorized_keys,
//     module.apt_upgrade,
//   ]
// }

module "hostname" {
  source = "./modules/hostname"
  connection = local.connectionkey

  hostname = var.hostname

  depends = [
    module.authorized_keys,
    module.apt_upgrade,
    // module.apt_install,
  ]
}

module "timezone" {
  source = "./modules/timezone"
  connection = local.connectionkey

  timezone = var.timezone

  depends = [
    module.authorized_keys,
    module.apt_upgrade,
    // module.apt_install,
    module.hostname,
  ]
}
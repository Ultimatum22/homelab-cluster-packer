variable "ip_adress" {
  type = string
}

variable "hostname" {
  type = string
  default = "rpi-host"
}

variable "initial_user" {
  type = string
}

variable "initial_password" {
  type = string
}

variable "timezone" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "reboot_waittime" {
  type = number
  default = 30
}
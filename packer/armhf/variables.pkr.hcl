variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "clone_vm" {
  type        = string
  description = "Name of existing VM template to clone"
}

variable "vm_name" {
  type        = string
  description = "Name of VM template"
}

variable "template_description" {
  type        = string
  description = "Description of VM template"
  default     = "Debian 11 base image"
}

variable "ip_address" {
  type        = string
  description = "Temporary IP address of VM template"
  default     = "192.168.2.250"
}

variable "gateway" {
  type        = string
  description = "Gateway of VM template"
  default     = "192.168.2.254"
}

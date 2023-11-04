variable "nomad_address" {
  type    = string
  default = "http://localhost:4646"
}

variable "base_hostname" {
  type    = string
  default = "twisted-wires.nl"
}

// variable "nomad_secret_id" {
//   type        = string
//   description = "Secret ID for ACL bootstrapped Nomad"
//   sensitive   = true
// }
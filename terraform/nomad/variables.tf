variable "nomad_address" {
  type        = string
  description = "Nomad server address"
  default     = "http://localhost:4646"
}


variable "datacenters" {
  type        = list(string)
  description = "The datacenters to run jobs."
  default     = ["homelab"]
}

variable "domain" {
  type        = string
  description = "The common domain name for all applications."
  default     = "twisted-wires.nl"
}

// variable "timezone" {
//   type        = string
//   description = "The timezone for all applications."
//   default     = "Europe/Amsterdam"
// }

module "acls" {
  source "./acls"

  nomad_address = var.nomad_address
  // nomad_secret_id = var.nomad_secret_id
}

terraform {
  required_version = ">=1.6.3"
}
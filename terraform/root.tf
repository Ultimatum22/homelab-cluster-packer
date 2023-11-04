module "acls" {
  source = "./modules/acls"

  nomad_address   = var.nomad_address
  nomad_secret_id = var.nomad_secret_id
}

terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.0.0"
    }
  }

  required_version = ">=1.6.3"
}
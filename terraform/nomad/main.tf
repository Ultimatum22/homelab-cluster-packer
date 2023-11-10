terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.0.0"
    }
  }
}

provider "nomad" {
  address     = var.nomad_address
  skip_verify = true
}

locals {
  apps        = "${path.module}/apps"
  datacenters = jsonencode(var.datacenters)
  domain      = var.domain
}

resource "nomad_job" "whoami" {
  jobspec = templatefile("${local.apps}/whoami.tpl",
    {
      datacenters      = local.datacenters
      whoami_count     = 1
      whoami_subdomain = "whoami"
      domain           = local.domain
    }
  )
}

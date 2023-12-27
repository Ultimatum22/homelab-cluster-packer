resource "nomad_acl_policy" "default-anonymous-policy" {
  name        = "anonymous"
  description = "Anonymous policy for Nomad"
  rules_hcl   = file("${path.module}/policy/anonymous.hcl")
}

resource "nomad_acl_policy" "default-developer-policy" {
  name        = "developer"
  description = "Application Developer policy"
  rules_hcl   = file("${path.module}/policy/developer.hcl")
}

resource "nomad_acl_policy" "default-operations-policy" {
  name        = "operations"
  description = "Production Operations policy"
  rules_hcl   = file("${path.module}/policy/operations.hcl")
}

resource "nomad_acl_token" "terraform-token" {
  name = "terraform"
  type = "management"
}

resource "nomad_acl_token" "vault-integration-token" {
  name = "vault"
  type = "management"
}

output "nomad_token" {
  value = nomad_acl_token.terraform-token.secret_id
}

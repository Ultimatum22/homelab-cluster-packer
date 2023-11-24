variable "connection" {
  type = map(any)
}

variable "depends" {
  default = []
}

# warning! the outputs are not updated even if the trigger re-runs the command!
variable "trigger" {
  default = ""
}

locals {}

resource "null_resource" "apt_upgrade" {
  triggers = {
    trigger = var.trigger
  }
  depends_on = [var.depends]

  connection {
    // Source <https://www.terraform.io/docs/provisioners/connection.html#argument-reference>
    type     = try(var.connection["type"], null)
    user     = try(var.connection["user"], null)
    password = try(var.connection["password"], null)
    host     = var.connection["host"] //Required
    port     = try(var.connection["port"], null)
    timeout  = try(var.connection["timeout"], null)

    certificate    = try(var.connection["certificate"], null)
    agent          = try(var.connection["agent"], null)
    agent_identity = try(var.connection["agent_identity"], null)
    host_key       = try(var.connection["host_key"], null)

    https    = try(var.connection["https"], null)
    insecure = try(var.connection["insecure"], null)
    use_ntlm = try(var.connection["use_ntlm"], null)
    cacert   = try(var.connection["cacert"], null)

    bastion_host        = try(var.connection["bastion_host"], null)
    bastion_host_key    = try(var.connection["bastion_host_key"], null)
    bastion_port        = try(var.connection["bastion_port"], null)
    bastion_user        = try(var.connection["bastion_user"], null)
    bastion_password    = try(var.connection["bastion_password"], null)
    bastion_certificate = try(var.connection["bastion_certificate"], null)
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"----------------\"",
      "echo \"update          \"",
      "echo \"----------------\"",
      "sudo apt-get update",
      "echo \"----------------\"",
      "echo \"list updates    \"",
      "echo \"----------------\"",
      "sudo apt-get list --upgradable",
      "echo \"----------------\"",
      "echo \"upgrade    \"",
      "echo \"----------------\"",
      "sudo apt-get upgrade -y",
      "echo \"----------------\"",
      "echo \"full-upgrade    \"",
      "echo \"----------------\"",
      "sudo apt-get full-upgrade -y",
      "echo \"----------------\"",
      "echo \"autoremove      \"",
      "echo \"----------------\"",
      "sudo apt-get autoremove -y",
      "echo \"----------------\"",
      "echo \"clean           \"",
      "echo \"----------------\"",
      "sudo apt-get clean -y"
    ]
  }
}
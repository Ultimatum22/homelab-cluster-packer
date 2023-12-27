terraform {
  backend "consul" {
    address = "192.168.2.223:8500"
    scheme  = "http"
    path    = "tfstate/nomad-tf"
  }
}

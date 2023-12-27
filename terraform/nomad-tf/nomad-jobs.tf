# Configure the Nomad provider
provider "nomad" {
  address = "http://192.168.2.223:4646"
}

data "template_file" "jenkins_template" {
  template = file("${path.module}/jobs/jenkins.hcl")

  vars =  {
    cert_resolver = data.vault_generic_secret.jenkins_secrets.data["cert_resolver"]
    host = data.vault_generic_secret.jenkins_secrets.data["host"]
  }
}

resource "nomad_job" "jenkins" {
  jobspec = data.template_file.jenkins_template.rendered
}

data "template_file" "keycloak_template" {
  template = file("${path.module}/jobs/keycloak.hcl")

  vars =  {
    db_user = data.vault_generic_secret.keycloak_db_secrets.data["user"]
    db_pass = data.vault_generic_secret.keycloak_db_secrets.data["password"]
    admin_user = data.vault_generic_secret.keycloak_app_secrets.data["admin_user"]
    admin_pass = data.vault_generic_secret.keycloak_app_secrets.data["admin_password"]
    cert_resolver = data.vault_generic_secret.keycloak_secrets.data["cert_resolver"]
    host = data.vault_generic_secret.keycloak_secrets.data["host"]
  }
}

resource "nomad_job" "keycloak" {
  jobspec = data.template_file.keycloak_template.rendered
}

resource "nomad_job" "traefik" {
  jobspec = file("${path.module}/jobs/traefik.hcl")
}

data "template_file" "oauth_proxy_traefik_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-traefik.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.traefik_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.traefik_oauth_proxy_secrets.data["cert-resolver"]}"
  }
}

resource "nomad_job" "oauth-proxy" {
  jobspec = data.template_file.oauth_proxy_traefik_template.rendered
}

data "template_file" "oauth_proxy_sickgear_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-sickgear.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.sickgear_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["cert-resolver"]}"
    upstream = "${data.vault_generic_secret.sickgear_oauth_proxy_secrets.data["upstream"]}"
  }
}

resource "nomad_job" "oauth-proxy-sickgear" {
  jobspec = data.template_file.oauth_proxy_sickgear_template.rendered
}


data "template_file" "oauth_proxy_sabnzb_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-sab.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.sabnzb_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["cert-resolver"]}"
    upstream = "${data.vault_generic_secret.sab_oauth_proxy_secrets.data["upstream"]}"
  }
}

resource "nomad_job" "oauth-proxy-sabnzb" {
  jobspec = data.template_file.oauth_proxy_sabnzb_template.rendered
}

data "template_file" "oauth_proxy_couchpotato_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-cp.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.couchpotato_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["cert-resolver"]}"
    upstream = "${data.vault_generic_secret.couchpotato_oauth_proxy_secrets.data["upstream"]}"
  }
}

resource "nomad_job" "oauth-proxy-couchpotato" {
  jobspec = data.template_file.oauth_proxy_couchpotato_template.rendered
}

data "template_file" "oauth_proxy_homebridge_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-homebridge.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.homebridge_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["cert-resolver"]}"
    upstream = "${data.vault_generic_secret.homebridge_oauth_proxy_secrets.data["upstream"]}"
  }
}

resource "nomad_job" "oauth-proxy-homebridge" {
  jobspec = data.template_file.oauth_proxy_homebridge_template.rendered
}

data "template_file" "oauth_proxy_transmission_template" {
  template = "${file("${path.module}/jobs/oauth-proxy-transmission.hcl")}"

  vars =  {
    client_secret = "${data.vault_generic_secret.transmission_openid_client.data["client_secret"]}"
    login_url= "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["login-url"]}"
    redeem_url = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["redeem-url"]}"
    validate_url = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["validate-url"]}"
    cookie_secret = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["cookie-secret"]}"
    host = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["cert-resolver"]}"
    upstream = "${data.vault_generic_secret.transmission_oauth_proxy_secrets.data["upstream"]}"
  }
}

resource "nomad_job" "oauth-proxy-transmission" {
  jobspec = data.template_file.oauth_proxy_transmission_template.rendered
}

resource "nomad_job" "route53-ddns-system" {
  jobspec = file("${path.module}/jobs/ddns.hcl")
}

data "template_file" "grafana_template" {
  template = "${file("${path.module}/jobs/grafana.hcl")}"

  vars =  {
    host = "${data.vault_generic_secret.grafana_config_secrets.data["host"]}"
    cert_resolver = "${data.vault_generic_secret.grafana_config_secrets.data["cert_resolver"]}"
  }
}

resource "nomad_job" "grafana" {
  jobspec = data.template_file.grafana_template.rendered
}

resource "nomad_job" "nats" {
  jobspec = file("${path.module}/jobs/nats.hcl")
}

resource "nomad_job" "boundary" {
  jobspec = file("${path.module}/jobs/boundary.hcl")
}

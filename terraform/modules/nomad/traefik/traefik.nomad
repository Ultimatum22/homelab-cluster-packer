job "traefik" {
  datacenters = ["homelab"]
  type = "service"
  priority = 100

  constraint {
    distinct_hosts = true
  }

  update {
    max_parallel = 1
    # canary = 1
    # auto_promote = true
    auto_revert = true
  }

  group "traefik" {
    count = 1

    network  {
      port "web" {
        static = 80
      }

      port "websecure" {
        static = 443
      }

      port "syslog" {
        static = 514
      }

      dns {
        servers = [
          "192.168.2.101",
          "192.168.2.102",
          "192.168.2.30",
          "192.168.2.170",
        ]
      }
    }

    ephemeral_disk {
      migrate = true
      sticky = true
    }

    service {
      name = "traefik"
      provider = "nomad"
      port = "web"

      check {
        type = "http"
        path = "/ping"
        port = "web"
        interval = "10s"
        timeout = "2s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.traefik.entryPoints=websecure",
        "traefik.http.routers.traefik.service=api@internal",
      ]
    }

    task "traefik" {
      driver = "docker"

      meta = {
        "diun.sort_tags" = "semver"
        "diun.watch_repo" = true
        "diun.include_tags" = "^[0-9]+\\.[0-9]+$"
      }

      config {
        image = "traefik:2.9"

        ports = ["web", "websecure"]
        network_mode = "host"

        mount {
          type = "bind"
          target = "/etc/traefik"
          source = "local/config"
        }

        mount {
          type = "bind"
          target = "/etc/traefik/usersfile"
          source = "secrets/usersfile"
        }
      }

      template {
        # Avoid conflict with TOML lists [[ ]] and Go templates {{ }}
        left_delimiter = "<<"
        right_delimiter = ">>"
        data = <<EOH
[log]
  level = "DEBUG"

[entryPoints]
  [entryPoints.web]
    address = ":80"
    [entryPoints.web.http]
      [entryPoints.web.http.redirections]
        [entryPoints.web.http.redirections.entrypoint]
          to = "websecure"
          scheme = "https"

  [entryPoints.websecure]
    address = ":443"
    [entryPoints.websecure.http.tls]
      certResolver = "letsEncrypt"
      [[entryPoints.websecure.http.tls.domains]]
        main = "*.<< with nomadVar "nomad/jobs" >><< .base_hostname >><< end >>"

  [entryPoints.metrics]
    address = ":8989"

  [entryPoints.syslogtcp]
    address = ":514"

  [entryPoints.syslogudp]
    address = ":514/udp"

[api]
  dashboard = true

[ping]
  entrypoint = "web"

[metrics]
  [metrics.prometheus]
    entrypoint = "metrics"
    # manualRouting = true

[providers.file]
  directory = "/etc/traefik/conf"
  watch = true

[providers.nomad]
  exposedByDefault = false
  defaultRule = "Host(`{{normalize .Name}}.<< with nomadVar "nomad/jobs" >><< .base_hostname >><< end >>`)"
  [providers.nomad.endpoint]
  address = "http://<< env "attr.unique.network.ip-address" >>:4646"

<< if nomadVarExists "nomad/jobs/traefik" ->>
[certificatesResolvers.letsEncrypt.acme]
  email = "<< with nomadVar "nomad/jobs/traefik" >><< .acme_email >><< end >>"
  # Store in /local because /secrets doesn't persist with ephemeral disk
  storage = "/local/acme.json"
  [certificatesResolvers.letsEncrypt.acme.dnsChallenge]
    provider = "cloudflare"
    resolvers = ["1.1.1.1:53", "8.8.8.8:53"]
    delayBeforeCheck = 0
<<- end >>
        EOH
        destination = "local/config/traefik.toml"
      }

      template {
        data = <<EOH
{{ with nomadVar "nomad/jobs/traefik" -}}
CF_DNS_API_TOKEN={{ .domain_lego_dns }}
CF_ZONE_API_TOKEN={{ .domain_lego_dns }}
{{- end }}
        EOH
        destination = "secrets/cloudflare.env"
        env = true
      }

      template {
        data = <<EOH
[http]
  [http.routers]
    [http.routers.nomad]
      entryPoints = ["websecure"]
      service = "nomad"
      rule = "Host(`nomad.{{ with nomadVar "nomad/jobs" }}{{ .base_hostname }}{{ end }}`)"
    [http.routers.hass]
      entryPoints = ["websecure"]
      service = "hass"
      rule = "Host(`hass.{{ with nomadVar "nomad/jobs" }}{{ .base_hostname }}{{ end }}`)"

  [http.services]
    [http.services.nomad]
      [http.services.nomad.loadBalancer]
        [[http.services.nomad.loadBalancer.servers]]
          url = "http://127.0.0.1:4646"
    [http.services.hass]
      [http.services.hass.loadBalancer]
        [[http.services.hass.loadBalancer.servers]]
          url = "http://192.168.3.65:8123"
        EOH
        destination = "local/config/conf/route-hashi.toml"
        change_mode = "noop"
      }

      template {
        data = <<EOH
{{ with nomadService "syslogng" -}}
[tcp.routers]
  [tcp.routers.syslogtcp]
    entryPoints = ["syslogtcp"]
    service = "syslogngtcp"
    rule = "HostSNI(`*`)"

[tcp.services]
  [tcp.services.syslogngtcp]
    [tcp.services.syslogngtcp.loadBalancer]
      {{ range . -}}
      [[tcp.services.syslogngtcp.loadBalancer.servers]]
        address = "{{ .Address }}:{{ .Port }}"
      {{ end -}}
{{- end }}

{{ with nomadService "syslogng" -}}
[udp.routers]
  [udp.routers.syslogudp]
    entryPoints = ["syslogudp"]
    service = "syslogngudp"

[udp.services]
  [udp.services.syslogngudp]
    [udp.services.syslogngudp.loadBalancer]
      {{ range . -}}
      [[udp.services.syslogngudp.loadBalancer.servers]]
        address = "{{ .Address }}:{{ .Port }}"
      {{ end -}}
{{- end }}
        EOH
        destination = "local/config/conf/route-syslog-ng.toml"
        change_mode = "noop"
      }

      template {
        data = <<EOH
[http.middlewares]
{{ with nomadVar "nomad/jobs/traefik" }}
{{ if .usersfile }}
  [http.middlewares.basic-auth.basicAuth]
  # TODO: Reference secrets mount
    usersFile = "/etc/traefik/usersfile"
{{- end }}
{{- end }}
        EOH
        destination = "local/config/conf/middlewares.toml"
        change_mode = "noop"
      }

      template {
        data = <<EOH
{{ with nomadVar "nomad/jobs/traefik" -}}
{{ .usersfile }}
{{- end }}
        EOH
        destination = "secrets/usersfile"
        change_mode = "noop"
      }

      resources {
        cpu = 100
        memory = 150
      }
    }
  }
}
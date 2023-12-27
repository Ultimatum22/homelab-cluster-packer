job "grafana" {
  region      = "global"
  datacenters = ["global"]
  type        = "service"

  constraint {
    attribute = "$${attr.unique.network.ip-address}"
    operator  = "!="
    value     = "192.168.2.223"
  }

  group "grafana" {
    volume "grafana_data" {
      type = "host"
      source = "grafana_data"
      read_only = false
    }
    volume "grafana_conf" {
      type = "host"
      source = "grafana_conf"
      read_only = false
    }

    count = 1

    task "grafana" {
      driver = "docker"

      config {
        image        = "grafana/grafana:latest"
        port_map = {
          http = 3000
        }

      }

      volume_mount {
        volume      = "grafana_data"
        destination = "/var/lib/grafana"
      }

      volume_mount {
        volume      = "grafana_conf"
        destination = "/etc/grafana"
      }

      resources {
        cpu    = 400
        memory = 256

        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "grafana"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.grafana.entryPoints=https",
          "traefik.http.routers.grafana.rule=Host(`${host}`)",
          "traefik.http.routers.grafana.tls.certresolver=${cert_resolver}"
        ]
      }
    }
  }
}

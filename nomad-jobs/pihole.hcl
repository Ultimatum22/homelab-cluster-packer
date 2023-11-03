job "pihole" {

  region = "global"

  datacenters = [
    "homelab",
  ]
  type = "service"

  group "svc" {
    count = 1

    restart {
      attempts = 5
      delay    = "15s"
    }

    task "app" {
      driver = "docker"

      config {
        image = "pihole/pihole:latest"
        mounts = [
          {
            type     = "bind"
            target   = "/etc/pihole"
            source   = "/mnt/storage/nomad/data/pihole/pihole"
            readonly = false
          },
          {
            type     = "bind"
            target   = "/etc/dnsmasq.d"
            source   = "/mnt/storage/nomad/data/pihole/dnsmasq.d"
            readonly = false
          },
        ]

        ports = ["http", "dns"]

        dns_servers = [
          "127.0.0.1",
          "1.1.1.1",
        ]
      }

      env = {
        "TZ"           = "insert_your_timezone"
        "WEBPASSWORD"  = "insert_your_password"
        "DNS1"         = "insert_your_dns_server_ip"
        "DNS2"         = "no"
        "INTERFACE"    = "eth0"
        "VIRTUAL_HOST" = "insert_your_virtual_host_fqdn"
        "ServerIP"     = "insert_your_raspberry_pi_server_ip"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    network {
      port "http" {
        to = "80"
      }
      port "dns" {
        static = "53"
      }
    }
  }
}
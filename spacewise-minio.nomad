job "spacewise-minio" {
  datacenters = ["dc1"]
  type        = "service"


  group "minio" {
    count = 1

    network {
      mode = "host"
      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }
      port "api" {
        to = 9000
        static = 9000
      }
      port "console" {
        to = 9001
        static = 9001
      }
    }

    service {
      name = "spacewise-minio-console"
      port = "console" 
      provider="nomad"
    }

    service {
      name = "spacewise-minio-api"
      port = "api" 
      provider="nomad"
    }

    volume "minio" {
      type      = "host"
      read_only = false
      source    = "minio"
    }

    task "minio" {
      driver = "docker"

      env {
        MINIO_ROOT_USER     = "spacewiseadmin"
        MINIO_ROOT_PASSWORD = "spacewisesecret"
      }

      config {
        image   = "spacewise-minio:v1"
        ports   = ["api", "console"] # Defined above, in `network` stanza
        command = "server"
        args    = [
          "/tmp/",
          "--address", ":${NOMAD_PORT_api}",
          "--console-address", ":${NOMAD_PORT_console}",
        ]
      }

      volume_mount {
        volume      = "minio"
        destination = "/data/db/minio"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 256
        memory_max = 512
      }

    }

  }

}
job "spacewise-mongo" {
  datacenters = ["dc1"]
  type = "service"

  group "spacewise-mongo" {
    count = 1
    spread {
      attribute = "${node.unique.id}"
    }
    
    network {
      mode = "host"
      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }
      
      port "mongo" {
        to     = 27017
        static = 27017
      }
      
    }

    volume "mongo" {
      type      = "host"
      read_only = false
      source    = "mongo"
    }
    
    task "spacewise-mongo" {
      driver = "docker"

      config {
        image = "spacewise-mongo:v1"
        ports = ["mongo"]
      }

      resources {
        cpu    = 2048
        memory = 1024
        memory_max = 3072
      }

      volume_mount {
        volume      = "mongo"
        destination = "/data/db"
        read_only   = false
      }

      service {
        name     = "spacewise-mongo"
        port     = "mongo"
        provider = "nomad"
      }
    }
  }
}

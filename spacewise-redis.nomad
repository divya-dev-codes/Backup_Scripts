job "spacewise-redis" {
  datacenters = ["dc1"]
  type = "service"

  group "spacewise-redis" {
    count = 1

    update {
      max_parallel = 1
    }

    migrate {
      max_parallel = 1
      health_check = "checks"
      min_healthy_time = "5s"
      healthy_deadline = "30s"
    }

    network {
      mode = "host" 
        dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
       }
        port "redis_port" { 
          to = 6379
          static = 6379
        } 
    }

    volume "redis-backend" {
        type      = "host"
        read_only = false
        source    = "redis-backend"
      }

    task "spacewise-redis" {
      driver = "docker"

      config {
        image = "spacewise-redis:v1"
        ports = [
            "redis_port"
        ]
      }

    volume_mount {
        volume      = "redis-backend"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 1024 
        memory = 128
        memory_max = 512 
      }

      service {
        name = "spacewise-redis"
        port = "redis_port"
        provider = "nomad"
      }

    }
  }
}
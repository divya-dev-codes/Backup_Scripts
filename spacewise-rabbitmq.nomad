job "spacewise-rabbitmq" {
  datacenters = ["dc1"]
  type        = "service"

  group "spacewise-rabbitmq" {
    count = 1

    network {
      mode = "host"

      port "ui" {
        to     = 15672
        static = 15672
      }

      port "amqp" {
        to     = 5672
        static = 5672
      }

      port "metric" {
        to     = 15692
        static = 15692
      }

      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }
    }

    volume "rabbitmq" {
        type      = "host"
        read_only = false
        source    = "rabbitmq"
      }

    task "spacewise-rabbitmq" {
      driver = "docker"

      config {
        image    = "spacewise-rabbitmq:v1"
        hostname = "${attr.unique.hostname}"
        ports    = ["ui", "amqp", "metric"]
      }

      volume_mount {
        volume      = "rabbitmq"
        destination = "/var/lib/rabbitmq"
        read_only   = false
      }

      resources {
        cpu    = 4096 
        memory = 512
        memory_max = 2048 
      }

      service {
        name     = "spacewise-rabbitmq-amqp"
        port     = "amqp"  
        provider = "nomad" 
      }

      service {
        name     = "spacewise-rabbitmq-ui"
        port     = "ui"   
        provider = "nomad"  
      }

      service {
        name     = "spacewise-rabbitmq-metric"
        port     = "metric"
        provider = "nomad"
      }
    }
  }
}
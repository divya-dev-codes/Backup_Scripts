job "spacewise-flower" {
  datacenters = ["dc1"]
  type        = "service"
  
  group "spacewise-flower" {
    count = 1
    
    network {
      mode = "host"
      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }
      port "http" {
        to = 5555
        static = 5555
      }
    }

    task "spacewise-flower" {
      driver = "docker"

      config {
        image   = "spacewise-flower:v1"
        ports   = ["http"]
        command = "celery"
        args    = ["--broker=${BROKER_URL}", "flower", "--broker-api=${BROKER_API}"]
        volumes = ["local/nomad.env:/dj_spacewise/devops/nomad.env"]
      }
       
      resources {
        cpu    = 1024
        memory = 256
        memory_max = 768
      }

      template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{range nomadService "spacewise-rabbitmq-amqp" }}
BROKER_URL=amqp://guest:guest@{{.Address}}:{{.Port}}/
BROKER_API=http://guest:guest@{{.Address}}:{{.Port}}/api/
{{ end }}
EOF
      }

      service {
        name         = "spacewise-flower"
        port         = "http"
      }
    }
  }
}

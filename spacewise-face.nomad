job "spacewise-face" {
  datacenters = ["dc1"]
  type = "service"

  group "spacewise-face"{
    count = 1
   
    spread {
      attribute = "${node.unique.id}"
    }
    network {
      mode = "host"
      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }

      port "http" {
        to = 8000
        static = 8000
      }
    }
  task "spacewise-face" {
    driver = "docker"

    config {
      image = "spacewise-face:v1"
      ports = [
        "http"
      ]
      volumes = [
        "local/nomad.env:/spacewise-face/env/nomad.env"
      ]
    }

    env {
      PORT=8000
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-face" -}}
REACT_APP_BASE_URL={{ .REACT_APP_BASE_URL }}
{{ end }}
EOF
     }
    resources {
      cpu = 100
      memory = 100 
      memory_max = 256
    }

    service {
        name = "spacewise-face"
        port = "http"
        provider = "nomad"
        }
  }
  }
}
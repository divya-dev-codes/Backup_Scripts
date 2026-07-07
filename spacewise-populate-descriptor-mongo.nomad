job "spacewise-populate-descriptor-mongo" {
  datacenters = ["dc1"]
  type = "batch"

  periodic {
    // Launch every 10 minutes
     crons = ["*/10 * * * *"]

    // Do not allow overlapping runs.
    prohibit_overlap = true
  }

  group "spacewise-populate-descriptor-mongo"{
    count = 1
    spread {
      attribute = "${node.unique.id}"
    }
    network {
      mode = "host"
      dns {
        servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
      }

    }
  task "spacewise-populate-descriptor-mongo" {
    driver = "docker"

    config {
      image = "spacewise-backend:v1"
      volumes = [
        "local/nomad.env:/dj_spacewise/devops/nomad.env"
      ]
    }

    env {
        IS_DOCKER_ENV = "True"
        STAGE = "docker"
        POPULATE_DESCRIPTOR_MONGO = "True"
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-populate-descriptor-mongo" -}}
DEFAULT_DB={{.DEFAULT_DB}}
GLOBAL_DB={{.GLOBAL_DB}}
DATABASE_ENGINE={{.DATABASE_ENGINE}}
DATABASE_NAME={{.DATABASE_NAME}}
DATABASE_USER={{.DATABASE_USER}}
DATABASE_PASSWORD={{.DATABASE_PASSWORD}}
DATABASE_HOST={{.DATABASE_HOST}}
DATABASE_PORT={{.DATABASE_PORT}}
DEFAULT_MONGO_CONNECTION={{.DEFAULT_MONGO_CONNECTION}}
{{- end -}}
{{range nomadService "spacewise-mongo" }}
MONGO_DATABASE_URL=mongodb://{{ .Address }}:{{ .Port }}
{{ end }}
{{range nomadService "spacewise-rabbitmq-amqp" }}
CELERY_BROKER_URL=amqp://guest:guest@{{.Address}}:{{.Port}}/
RMQ_HOST={{.Address}}
RMQ_PORT={{.Port}}
{{ end }}
{{range nomadService "spacewise-redis" }}
CELERY_RESULT_BACKEND=redis://{{.Address}}:{{.Port}}/
REDIS_HOST={{.Address}}
REDIS_PORT={{.Port}}
{{ end }}
EOF
     }
    resources {
      cpu = 4096
      memory = 512
      memory_max = 4096
    }

  }
   }
  }
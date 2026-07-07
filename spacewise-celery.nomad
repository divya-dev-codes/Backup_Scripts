job "spacewise-celery" {
  datacenters = ["dc1"]
  type = "service"

  group "celery" {
   count = 1

  task "DYNAMIC_QUERY" {
    driver = "docker"

    config {
      image = "spacewise-backend:v1"
      network_mode = "host"
      volumes = [
        "local/nomad.env:/dj_spacewise_job/devops/nomad.env"
      ]
    }

    env {
        STAGE = "docker"
        IS_DOCKER_ENV = "True"
        DYNAMIC_QUERY = "True"
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-celery" -}}
UPLOAD_TO_MINIO={{.UPLOAD_TO_MINIO}}
MINIO_BUCKET_NAME={{.MINIO_BUCKET_NAME}}
MINIO_URL={{.MINIO_URL}}
SECRET_KEY={{.SECRET_KEY}}
SECURE={{.SECURE}}
ACCESS_KEY={{.ACCESS_KEY}}
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
RMQ_PORT={{.Port}}
{{ end }}
EOF
     }
     resources {
      cpu = 10000
      memory = 4000
      memory_max = 4500
     }
  }

  task "DATA_INGESTION" {
    driver = "docker"

    config {
      image = "spacewise-backend:v1"
      network_mode = "host"
      volumes = [
        "local/nomad.env:/dj_spacewise_job/devops/nomad.env"
      ]
    }

    env {
        STAGE = "docker"
        IS_DOCKER_ENV = "True"
        DATA_INGESTION = "True"
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-celery" -}}
UPLOAD_TO_MINIO={{.UPLOAD_TO_MINIO}}
MINIO_BUCKET_NAME={{.MINIO_BUCKET_NAME}}
MINIO_URL={{.MINIO_URL}}
SECRET_KEY={{.SECRET_KEY}}
SECURE={{.SECURE}}
ACCESS_KEY={{.ACCESS_KEY}}
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
      cpu = 2000
      memory = 1024
      memory_max = 1536 
     }
  }

   task "REPORTS_QUEUE" {
    driver = "docker"

    config {
      image = "spacewise-backend:v1"
      network_mode = "host"
      volumes = [
        "local/nomad.env:/dj_spacewise_job/devops/nomad.env"
      ]
    }

    env {
        STAGE = "docker"
        IS_DOCKER_ENV = "True"
        REPORTS_QUEUE = "True"
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "restart"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-celery" -}}
UPLOAD_TO_MINIO={{.UPLOAD_TO_MINIO}}
MINIO_BUCKET_NAME={{.MINIO_BUCKET_NAME}}
MINIO_URL={{.MINIO_URL}}
SECRET_KEY={{.SECRET_KEY}}
SECURE={{.SECURE}}
ACCESS_KEY={{.ACCESS_KEY}}
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
      cpu = 2000
      memory = 512
      memory_max = 1024
     }
  }
  }
}

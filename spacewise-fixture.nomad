job "spacewise-fixture" {
  datacenters = ["dc1"]
  type = "batch"
  
  group "fixture" {
    task "fixture" {
    driver = "docker"

    config {
      image = "spacewise-backend:v1"
    }

    env {
        STAGE = "docker"
        IS_DOCKER_ENV = "True"
        FIXTURE = "True"
    }

    template {
        destination = "local/docker.env"
        env         = true
        change_mode = "noop"
        data        = <<EOF
{{- with nomadVar "nomad/jobs/spacewise-fixture" -}}
DJANGO_SETTINGS_MODULE={{.DJANGO_SETTINGS_MODULE}}
CORS_ALLOWED_ORIGINS={{.CORS_ALLOWED_ORIGINS}}
CORS_ORIGIN_ALLOW_ALL={{.CORS_ORIGIN_ALLOW_ALL}}
CORS_ALLOW_CREDENTIALS={{.CORS_ALLOW_CREDENTIALS}}
DEBUG={{.DEBUG}}
ALLOWED_HOSTS={{.ALLOWED_HOSTS}}
DJANGO_URL={{.DJANGO_URL}}
INGEST_JSON_URL={{.INGEST_JSON_URL}}
DOCS_DIRECTORY={{.DOCS_DIRECTORY}}
BASE_URL_PREFIX={{.BASE_URL_PREFIX}}
UPLOAD_TO_MINIO={{.UPLOAD_TO_MINIO}}
MINIO_BUCKET_NAME={{.MINIO_BUCKET_NAME}}
MINIO_URL={{.MINIO_URL}}
SECRET_KEY={{.SECRET_KEY}}
SECURE={{.SECURE}}
ACCESS_KEY={{.ACCESS_KEY}}
DEFAULT_DB={{.DEFAULT_DB}}
GLOBAL_DB={{.GLOBAL_DB}}
PROJECT_NAME={{.PROJECT_NAME}}
DATABASE_ENGINE={{.DATABASE_ENGINE}}
DATABASE_NAME={{.DATABASE_NAME}}
DATABASE_USER={{.DATABASE_USER}}
DATABASE_PASSWORD={{.DATABASE_PASSWORD}}
DATABASE_HOST={{.DATABASE_HOST}}
DATABASE_PORT={{.DATABASE_PORT}}
DEFAULT_MONGO_CONNECTION={{.DEFAULT_MONGO_CONNECTION}}
SERVER_HOST={{.SERVER_HOST}}
SERVER_PORT={{.SERVER_PORT}}
DEFAULT_AUTO_FIELD={{.DEFAULT_AUTO_FIELD}}
FIXTURE_DIRS={{.FIXTURE_DIRS}}
DJANGO_LOG_LEVEL_STRING={{.DJANGO_LOG_LEVEL_STRING}}
CORS_ALLOWED_ORIGINS={{.CORS_ALLOWED_ORIGINS}}
CORS_ORIGIN_ALLOW_ALL={{.CORS_ORIGIN_ALLOW_ALL}}
CORS_ALLOW_CREDENTIALS={{.CORS_ALLOW_CREDENTIALS}}
ALLOWED_HOSTS={{.ALLOWED_HOSTS}}
ABSOLUTE_ROOT_URL={{.ABSOLUTE_ROOT_URL}}
TEMPLATES_DIRECTORY={{.TEMPLATES_DIRECTORY}}
CUSTOM_STATIC={{.CUSTOM_STATIC}}
STATIC_URL={{.STATIC_URL}}
STATIC_FILES={{.STATIC_FILES}}
STATIC={{.STATIC}}
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
      cpu = 512
      memory = 512
      memory_max = 1024 
    }
  }
  }
}
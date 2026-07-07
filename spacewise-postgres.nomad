job "spacewise-postgres" {
    datacenters = ["dc1"]
    type = "service"

    group "postgres" {
        count = 1

        network {
            mode = "host"
            port "db" { 
                to = 5432 
                static = 5432
            }

            dns {
            servers = ["172.17.0.1", "8.8.8.8", "8.8.4.4"]
            }
        }

     volume "postgres" {
        type      = "host"
        read_only = false
        source    = "postgres"
      }


        task "postgres" {
        driver = "docker"
        config {
            image = "spacewise-postgres:v1"
            ports = ["db"]
        }

      volume_mount {
        volume      = "postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }
      
        env {
            POSTGRES_USER="linpostgres"
            POSTGRES_PASSWORD="114@spacewise"
            POSTGRES_DB = "spacewise"
        }
        logs {
            max_files     = 5
            max_file_size = 15
        }

        resources {
            cpu = 3000
            memory = 1024
            memory_max = 4096

        }
        }

        service {
            name = "spacewise-postgres"
            provider = "nomad"
            port = "db"
        }

        restart {
            attempts = 10
            interval = "5m"
            delay = "25s"
            mode = "delay"
        }

    }
}
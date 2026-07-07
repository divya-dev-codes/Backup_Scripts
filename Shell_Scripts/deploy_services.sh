export NOMAD_ADDR=http://127.0.0.1:4646

nomad run ./Jobs/spacewise-postgres.nomad
sleep 5
nomad run ./Jobs/spacewise-mongo.nomad
sleep 5
nomad run ./Jobs/spacewise-rabbitmq.nomad
sleep 5
nomad run ./Jobs/spacewise-flower.nomad
sleep 5
nomad run ./Jobs/spacewise-minio.nomad
sleep 5
nomad run ./Jobs/spacewise-redis.nomad 
sleep 10


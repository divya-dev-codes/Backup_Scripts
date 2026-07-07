export NOMAD_ADDR=http://127.0.0.1:4646

nomad run ./Jobs/spacewise-redis-populate.nomad
sleep 5
nomad run ./Jobs/spacewise-populate-descriptor-mongo.nomad
sleep 5
nomad run ./Jobs/spacewise-scrape-spacetrack.nomad
sleep 10 
clear
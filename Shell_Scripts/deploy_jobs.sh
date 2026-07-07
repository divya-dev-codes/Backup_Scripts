export NOMAD_ADDR=http://127.0.0.1:4646

nomad run ./Jobs/spacewise-backend.nomad
sleep 5
nomad run ./Jobs/spacewise-celery.nomad
sleep 5
nomad run ./Jobs/spacewise-face.nomad
sleep 5
nomad run ./Jobs/spacewise-node.nomad
sleep 5
nomad run ./Jobs/spacewise-fixture.nomad
sleep 10
clear


export NOMAD_ADDR=http://127.0.0.1:4646
cd Variables
nomad var put nomad/jobs/spacewise-backend  @spacewise-backend.hcl
nomad var put nomad/jobs/spacewise-celery  @spacewise-celery.hcl
nomad var put nomad/jobs/spacewise-populate-descriptor-mongo  @spacewise-populate-descriptor-mongo.hcl
nomad var put nomad/jobs/spacewise-redis-populate @spacewise-redis-populate.hcl
nomad var put nomad/jobs/spacewise-scrape-spacetrack @spacewise-scrape-spacetrack.hcl
nomad var put nomad/jobs/spacewise-face @spacewise-face.hcl
nomad var put nomad/jobs/spacewise-fixture @spacewise-fixture.hcl 
cd ..
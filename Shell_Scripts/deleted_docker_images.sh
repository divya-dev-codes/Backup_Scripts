# Get the list of currently loaded docker images
loaded_images=$(docker images --format="{{.Repository}}")

# Define the list of images you want to load
desired_images=(
  "spacewise-backend"
  "spacewise-face"
  "spacewise-flower"
  "spacewise-mongo"
  "spacewise-rabbitmq"
  "spacewise-redis"
  "spacewise-postgres"
  "spacewise-minio"
)

# Loop through the desired images and load the missing ones
for image in "${desired_images[@]}"; do
  if ! echo "$loaded_images" | grep -q "$image"; then
    sudo docker load -i "/home/ubuntu/docker-images/$image.tar.gz"
  fi
done

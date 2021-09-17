docker-compose -f deploy/docker-compose.yml pull blue

docker-compose -f deploy/docker-compose.yml rm -s -f blue
docker-compose -f deploy/docker-compose.yml up -d blue
docker-compose -f deploy/docker-compose.yml rm -s -f green
docker-compose -f deploy/docker-compose.yml up -d green

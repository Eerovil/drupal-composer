#!/bin/sh

docker-compose up -d --build

# Parallel downloads, from
# https://stackoverflow.com/a/38102206/10403865
docker-compose exec web composer global require hirak/prestissimo


docker-compose exec web composer install
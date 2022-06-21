#!/bin/bash

. .env

NAMED_VOLUME=${NAMED_VOLUME}
NETWORKS_DEFAULT_EXTERNAL_NAME=${NETWORKS_DEFAULT_EXTERNAL_NAME}
DEV_MONGO_PORT=${DEV_MONGO_PORT}

devmongoports=''
if [[ ! -z ${DEV_MONGO_PORT} ]]
then
devmongoports="
    ports:
      - '${DEV_MONGO_PORT}:27017'"
fi

mongo_data_dir='./dbdata'
volumes=''
if [[ ! -z ${NAMED_VOLUME} ]]
then
mongo_data_dir=${NAMED_VOLUME}

volumes="

volumes:
  ${NAMED_VOLUME}:"
fi

networks=''
if [[ ! -z ${NETWORKS_DEFAULT_EXTERNAL_NAME} ]]
then
networks="

networks:
  default:
    external:
      name: ${NETWORKS_DEFAULT_EXTERNAL_NAME}"
fi

cat > docker-compose.yml <<EOF
version: '3.3'

services:
  ${MONGO_NAME}:
    image: mongo
    restart: unless-stopped
    container_name: ${MONGO_NAME}${devmongoports}
    volumes:
      - ${mongo_data_dir}:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${DB_USER}
      - MONGO_INITDB_ROOT_PASSWORD=${DB_PASS}${volumes}${networks}
EOF

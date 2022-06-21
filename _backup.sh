#!/bin/bash

. .env

if [ -z $1 ]; 
  then 
    echo "Database name required. No action taken.";
    exit 1;
  fi

docker exec $MONGO_NAME sh -c "mongodump \
  -d $1 \
  -u $DB_USER \
  -p $DB_PASS \
  --authenticationDatabase admin \
  --archive" > $1.dump
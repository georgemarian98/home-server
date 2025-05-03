#!/bin/bash

usage()
{
    printf "Usage: $0 -r -f <DOCKER_SERVICE_NAME>
    -r - Remove the service(s)
    -f - Start/Remove just a specific service\n"
    exit 1
}

SERVICE=""
REMOVE=""
while getopts "f:r" arg;
do
    case $arg in
        f) SERVICE=$OPTARG ;;
        r) REMOVE="true" ;;
        *) usage
    esac
done

DOCKER_FILES=$(find  -name "docker-compose.yaml" -type f)

if [ ! -z "$SERVICE" ]; 
then
    for file in $DOCKER_FILES;
    do
        if [[ "$file" == *"$SERVICE"* ]]; 
        then
            DOCKER_FILES=$file
            break
        fi
    done
fi

echo "Services: "
for file in $DOCKER_FILES;
do
    SERVICE_NAME=$(basename $(dirname $file))
    if [ ! -z "$REMOVE" ]; 
    then
        docker-compose -f $file --env-file ./.env -- down
    else
        docker-compose -f $file --env-file ./.env -- pull
        docker-compose -f $file --env-file ./.env -- up -d
    fi
    echo "---------------------------------------------------"
done

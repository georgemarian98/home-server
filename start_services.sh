#!/bin/bash

usage()
{
    printf "Usage: $0 -c <NEW_SERVICE_NAME> -r -f <DOCKER_SERVICE_NAME>
    -c - Create a new folder with the README and the docker compose file for the new service
    -r - Remove the service(s)
    -f - Start/Remove just a specific service\n"
    exit 1
}

create_new_service()
{
    local SERVICE_NAME=$1
    mkdir ./$SERVICE_NAME
    printf "# ${SERVICE_NAME^}\n" > ./$SERVICE_NAME/README.md
    printf "version: '3.7'\n" > ./$SERVICE_NAME/docker-compose.yaml
    exit 0
}

main()
{
    local DOCKER_FILES=$(find -maxdepth 2 -name "docker-compose.yaml" -type f)

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
        local SERVICE_NAME=$(basename $(dirname $file))
        if [ ! -z "$REMOVE" ]; 
        then
            docker-compose -f $file --env-file ./.env -- down
        else
            docker-compose -f $file --env-file ./.env -- pull
            docker-compose -f $file --env-file ./.env -- up -d
        fi
        echo "---------------------------------------------------"
    done
}

SERVICE=""
REMOVE=""
while getopts "c:f:r" arg;
do
    case $arg in
        c) create_new_service $OPTARG ;;
        f) SERVICE=$OPTARG ;;
        r) REMOVE="true" ;;
        *) usage
    esac
done

main

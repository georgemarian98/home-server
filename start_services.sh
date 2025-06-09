#!/bin/bash

usage()
{
    printf "Usage: $0 -c <NEW_SERVICE_NAME> -r -f <DOCKER_SERVICE_NAME> -d
    -c - Create a new folder with the README and the docker compose file for the new service
    -r - Remove the service(s)
    -f - Start/Remove just a specific service
    -d - Debug mode\n"
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
        DOCKER_FILES=$(echo "$DOCKER_FILES" | grep $SERVICE)
    fi

    echo "Services: "
    [ ! -z "$DEBUG" ] && echo $DOCKER_FILES

    for file in $DOCKER_FILES;
    do
        local SERVICE_DIRECTORY=$(dirname $file)

        # Merge the env files
        cat ./.env > ./.env_merged
        [ -f "$SERVICE_DIRECTORY/.env" ] && cat $SERVICE_DIRECTORY/.env >> ./.env_merged

        if [ ! -z "$REMOVE" ]; 
        then
            docker-compose -f $file --env-file ./.env_merged -- down
        else
            docker-compose -f $file --env-file ./.env_merged -- pull
            docker-compose -f $file --env-file ./.env_merged -- up -d
        fi
        echo "---------------------------------------------------"

        [ -z "$DEBUG" ] && rm ./.env_merged
    done
}

SERVICE=""
REMOVE=""
DEBUG=""
while getopts "c:f:rd" arg;
do
    case $arg in
        c) create_new_service $OPTARG ;;
        f) SERVICE=$OPTARG ;;
        r) REMOVE="true" ;;
        d) DEBUG="true" ;;
        *) usage
    esac
done

main

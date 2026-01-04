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
    ls $SERVICE_NAME &> /dev/null
    if [ $? -eq 0 ];
    then
        echo "The service '$SERVICE_NAME' already exists"
        exit 1
    fi
    mkdir ./$SERVICE_NAME
    printf "# ${SERVICE_NAME^}\n" > ./$SERVICE_NAME/README.md
    
    cat << EOF > ./$SERVICE_NAME/docker-compose.yaml

services:
  ${SERVICE_NAME}:
    image: __SERVICE_IMAGE__ # Change to the service image
    container_name: ${SERVICE_NAME}
    restart: unless-stopped    
    pull_policy: always
    networks:
      - frontend
    labels:
      - "traefik.http.routers.${SERVICE_NAME}.rule=Host(\`${SERVICE_NAME}.rlgland.site\`)"
      - "traefik.http.routers.${SERVICE_NAME}.entrypoints=websecure"
      - "traefik.http.routers.${SERVICE_NAME}.tls.certresolver=cloudflare"
      - "traefik.http.services.${SERVICE_NAME}.loadbalancer.server.port=__SERVICE_PORT__" # Change to the internal port of the service

networks:
  frontend:
    external: true
EOF

    touch ./$SERVICE_NAME/.gitignore
    exit 0
}

init_homelab()
{
    # Create the networks if they don't exist
    docker network inspect frontend >/dev/null 2>&1 || docker network create frontend
    docker network inspect backend >/dev/null 2>&1 || docker network create backend
}

main()
{
    init_homelab
    
    local DOCKER_FILES=$(find -maxdepth 2 -name "docker-compose.yaml" -type f)
    if [ ! -z "$SERVICES" ];
    then
        DOCKER_FILES=$(echo "$DOCKER_FILES" | grep -E "/($SERVICES)/docker-compose.yaml$")
    fi

    echo "Services: "
    [ ! -z "$DEBUG" ] && echo $DOCKER_FILES

    for file in $DOCKER_FILES;
    do
        local SERVICE_DIRECTORY=$(dirname $file)

        # Merge the env files
        cat ./.env > ./.env_merged
        echo "" >> ./.env_merged
        [ -f "$SERVICE_DIRECTORY/.env" ] && cat $SERVICE_DIRECTORY/.env >> ./.env_merged

        if [ ! -z "$REMOVE" ]; 
        then
            docker compose -f $file --env-file ./.env_merged down
        else
            docker compose -f $file --env-file ./.env_merged pull
            docker compose -f $file --env-file ./.env_merged up -d
        fi
        echo "---------------------------------------------------"

        [ -z "$DEBUG" ] && rm ./.env_merged
    done
}

SERVICES=""
REMOVE=""
DEBUG=""
while getopts "c:f:rd" arg;
do
    case $arg in
        c) create_new_service $OPTARG ;;
        f) SERVICES="$SERVICES|$OPTARG" ;;
        r) REMOVE="true" ;;
        d) DEBUG="true" ;;
        *) usage
    esac
done

main

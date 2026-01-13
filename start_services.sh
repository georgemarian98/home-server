#!/bin/bash

usage()
{
    printf "Usage: $0 -c <NEW_SERVICE_NAME> -r -f <DOCKER_SERVICE_NAME> -d
    -c - Create a new folder with the README and the docker compose file for the new service
    -r - Remove the service(s)
    -f - Start/Remove just a specific service
    -s - Deploy the stack in swarm mode
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

main()
{
    # Initialize the homelab networks if they don't exist
    docker network inspect frontend >/dev/null 2>&1 || docker network create frontend
    docker network inspect backend >/dev/null 2>&1 || docker network create backend
    
    # Find all docker-compose.yaml files and if a specific service is requested, filter the results
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
        if ls $SERVICE_DIRECTORY/.env.compose &> /dev/null; 
        then
            # .env.compose file exists, use it for processing the docker compose file
            ADDITIONAL_ENV_FILE="--env-file $SERVICE_DIRECTORY/.env.compose"
        fi

        if [ ! -z "$REMOVE" ]; 
        then
            # Remove the service
            $DOCKER_COMPOSE_CMD -f $file --env-file $ADDITIONAL_ENV_FILE .env down
           
        else
            # Start the service
            $DOCKER_COMPOSE_CMD -f $file --env-file $ADDITIONAL_ENV_FILE .env pull
            $DOCKER_COMPOSE_CMD -f $file --env-file $ADDITIONAL_ENV_FILE .env up -d
        fi
        echo "---------------------------------------------------"
    done
}

main_swarm()
{
    # Find all docker-compose.yaml files and if a specific service is requested, filter the results
    docker network inspect frontend-swarm >/dev/null 2>&1 || docker network create frontend-swarm --driver=overlay --attachable
    docker network inspect backend-swarm >/dev/null 2>&1 || docker network create backend-swarm --driver=overlay
    export HOSTNAME=$(hostname)

    local DOCKER_FILES=$(find -maxdepth 2 -name "docker-compose-swarm.yaml" -type f)
    if [ ! -z "$SERVICES" ];
    then
        DOCKER_FILES=$(echo "$DOCKER_FILES" | grep -E "/($SERVICES)/docker-compose-swarm.yaml$")
    fi

    echo "Services: "

    for file in $DOCKER_FILES;
    do
        local SERVICE_DIRECTORY=$(dirname $file)
        local SERVICE_NAME=$(basename $SERVICE_DIRECTORY)

        if ls $SERVICE_DIRECTORY/.env.compose &> /dev/null; 
        then
            # .env.compose file exists, use it for processing the docker compose file
            ADDITIONAL_ENV_FILE="--env-file $SERVICE_DIRECTORY/.env.compose"
        fi

        if [ ! -z "$REMOVE" ]; 
        then
            # Remove the service
            docker stack rm $SERVICE_NAME
           
        else
            # Substitute environment variables from both .env and .env.compose and get the final compose file
            docker compose -f $file --env-file .env $ADDITIONAL_ENV_FILE config > docker-compose-merged.yaml
            
            # Start the service
            $DOCKER_COMPOSE_CMD -f docker-compose-merged.yaml --env-file .env $ADDITIONAL_ENV_FILE pull
            docker stack deploy -c docker-compose-merged.yaml $SERVICE_NAME
           
        fi
        echo "---------------------------------------------------"
    done
}

SERVICES=""
REMOVE=""
DEBUG=""
SWARM=""
while getopts "c:f:rds" arg;
do
    case $arg in
        c) create_new_service $OPTARG ;;
        f) SERVICES="$SERVICES|$OPTARG" ;;
        r) REMOVE="true" ;;
        d) DEBUG="true" ;;
        s) SWARM="true" ;;
        *) usage
    esac
done

DOCKER_COMPOSE_CMD="docker-compose"
if ! command -v $DOCKER_COMPOSE_CMD >/dev/null 2>&1
then
    DOCKER_COMPOSE_CMD="docker compose"
fi

if [ ! -z "$SWARM" ];
then
    main_swarm
    exit 0
fi
main

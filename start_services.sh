#!/bin/bash

DOCKER_FILES=$(find -name "docker-compose.yaml" -type f)
echo "Services: "
echo "$DOCKER_FILES" | awk -F/ '{ printf "    %s\n", $2 }'

SERVICE=""
while getopts "f:" arg;
do
    case $arg in
        f) SERVICE=$OPTARG ;;
    esac
done

if [ ! -z "$SERVICE" ]; then
    # use grep instead, it's more readable
    for file in $DOCKER_FILES;
    do
        if [[ "$file" == *"$SERVICE"* ]];
        then
            DOCKER_FILES=$file
            break
        fi
    done
fi

docker-compose --verbose -f $DOCKER_FILES up
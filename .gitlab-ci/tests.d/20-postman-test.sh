#!/bin/bash
# Runs automated API calls against running solution to verify software is configured and/or connected

#get docker network name
PROJECT_DIR_NAME=$(pwd | awk -F "/" '{print $NF}')
DOCKER_NW=$(docker network ls | grep $PROJECT_DIR_NAME | awk '{print $2}')

POSTMANRUN=$(docker run -t --network="$DOCKER_NW" postman/newman run --insecure https://api.getpostman.com/collections/12861248-cc188562-59d9-4326-9fc0-6bcbd709f934?apikey=$POSTMAN_API)

# Filters results and returns as a 6 digit number - expected to have 00000 for successful testing
RESULT=$(echo "$POSTMANRUN" | grep -A 8 "iterations" | awk '{print $6}' | sed -e '/^$/d' | tr -d '\n')

# Checks return of API calls have no failed responses
if [[ "$RESULT" != "00000" ]]; then
    echo "One or more tests failed..."
    echo "$POSTMANRUN"
    exit 1
else
    echo "Tests completed successfully..."
    echo "$POSTMANRUN"
    exit 0
fi

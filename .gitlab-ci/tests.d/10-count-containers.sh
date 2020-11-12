#!/bin/bash
# Verify all 6 containers run from startup
#set -x

CONTAINERCOUNT=$(docker ps --format '{{.Names}}' -f status=running | grep -v pingcentral-db-loader | wc -l)
CONTAINERSEXPECTED=7
SECONDS=0
SECONDSMAX=3000
SECONDSLIMIT=$(($SECONDSMAX+25))

while [ $SECONDS -le $SECONDSLIMIT ]
do
    CONT_STATUS=$(docker ps --format '{{.Names}} {{.Status}}')
    #check that we still have $CONTAINERSEXPECTED num of containers. error if we don't.
    CONTAINERCOUNT=$(echo "$CONT_STATUS" | grep -v pingcentral-db-loader | wc -l)
    if [ $CONTAINERCOUNT -ne $CONTAINERSEXPECTED ]; then
        #if there's less containers (i.e. directory dies), print the docker logs and exit 1.
        echo "$CONTAINERSEXPECTED containers expected. $CONTAINERCOUNT containers found..."
    echo "$CONT_STATUS"
        docker-compose logs --tail="100"
        exit 1
    fi
    #looks for unhealthy|starting containers
    STARTING_CONT=$(printf '%s\n' "${CONT_STATUS[@]}" | awk '/unhealthy|starting/')
    if echo "$STARTING_CONT" ; then
        echo "Waiting for containers to start..."
    #exit with error if any container is in an unhealthy state
    elif printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'unhealthy'; then
        UNHEALTHY_CONT=$(echo "$CONT_STATUS" | grep "unhealthy")
        if  ${UNHEALTHY_TIMER+"false"} ; then
        UNHEALTHY_TIMER=$SECONDS+120
        fi
        #check if pingfederate unhealthy, wait 1200 seconds
        if [ $UNHEALTHY_TIMER -le $SECONDS ]; then
            echo "Waiting 90 seconds for containers to become healthy..."
            echo $UNHEALTHY_CONT | sed -e 's/Up.*unhealthy)/Error: is unhealthy. /'
            docker-compose logs --tail="100"
            echo "$CONT_STATUS"
            exit 1
        fi
        if [ -z "$UNHEALTHY_CONT" ]; then
            echo "No containers reporting unhealthy..."
        fi
    else
        echo "$CONT_STATUS"
        exit 0
    fi

    #exit with error if time greater than allowed
    if [[ $SECONDS -ge $SECONDSLIMIT ]]; then
    exit 1
    fi

    #if no containers remaining in capture move on
    if [ "${STARTING_CONT:-0}" == 0 ]; then
    exit 0
    fi 

    #wait
    sleep 30
done


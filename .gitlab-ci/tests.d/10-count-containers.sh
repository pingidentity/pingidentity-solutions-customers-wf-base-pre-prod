#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSMAX=3000
SECONDSLIMIT=$(($SECONDSMAX+25))


if [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ]; then
echo "$CONTAINERSEXPECTED containers expected. $CONTAINERCOUNT containers found..."
elif [ $CONTAINERCOUNT -ne $CONTAINERSEXPECTED ]; then
echo "$CONTAINERSEXPECTED containers expected. $CONTAINERCOUNT containers found..."
exit 1 
fi


#CONTAINER_STATUS=$(docker ps --format '{{.Names}} {{.Status}}' | sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting)

while [ $SECONDS -le $SECONDSLIMIT ]
do
    CONT_STATUS=$(docker ps --format '{{.Names}} {{.Status}}')
    #check that we still have $CONTAINERSEXPECTED num of containers. error if we don't.
    CONTAINERCOUNT=$(echo "$CONT_STATUS" | wc -l)
    if [ $CONTAINERCOUNT -ne $CONTAINERSEXPECTED ]; then
        #if there's less containers (i.e. directory dies), print the docker logs and exit 1.
        echo "$CONTAINERSEXPECTED containers expected. $CONTAINERCOUNT containers found..."
        docker-compose logs --tail="100"
        exit 1
    fi
    #looks for unhealthy|starting containers     
    if printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'starting'; then
        echo "Waiting for containers to start..."
        STARTING_CONT=$(echo "$CONT_STATUS" |  sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting)
        echo "$STARTING_CONT"
        #check if 3 or less containers running and then print docker logs
        #LINE_CHECK=$(echo -n "$STARTING_CONT" | grep -c '^')
        #if (( $LINE_CHECK <= 3 )); then
        #    docker-compose logs --tail="20"
        #fi
    #exit with error if any container is in an unhealthy state
    elif printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'unhealthy'; then
        UNHEALTHY_CONT=$(echo "$CONT_STATUS" | grep "unhealthy")
        if  ${PINGFED_COUNT+"false"} ; then
        PINGFED_COUNT=$SECONDS
        fi
        #check if pingfederate unhealthy, wait 60 seconds
        if echo $UNHEALTHY_CONT | grep -q 'pingfederate' && (( $PINGFED_COUNT+60 <= $SECONDS )); then
            echo $UNHEALTHY_CONT | sed -e 's/Up.*unhealthy)/Error: is unhealthy. /'
            docker-compose logs --tail="100"
            exit 1
        #if pingfederate not in there anymore and something is unhealthy then exit 1
        elif echo $UNHEALTHY_CONT | grep -qv 'pingfederate'; then
            echo $UNHEALTHY_CONT | sed -e 's/Up.*unhealthy)/Error: is unhealthy. /'
            docker-compose logs --tail="100"
            exit 1
        fi
    else
        echo "$CONT_STATUS"
        exit 0    
    fi

    sleep 20

    #exit with error if time greater than allowed
    if [[ $SECONDS -ge $SECONDSLIMIT ]]; then
    exit 1
    fi
 
done

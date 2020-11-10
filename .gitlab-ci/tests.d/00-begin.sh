#!/bin/bash
# Script checks server profile directories are present and contain content

set +x

# Verify if server profile directories exist
PINGCENTRALDIR="./server-profile/pingcentral"
PINGDATASYNCDIR="./server-profile/pingdatasync"
PINGDELEGATORDIR="./server-profile/pingdelegator"
PINGDIRECTORYDIR="./server-profile/pingdirectory"
PINGFEDERATEDIR="./server-profile/pingfederate"

declare -a server_profiles=($PINGCENTRALDIR
                            $PINGDATASYNCDIR
                            $PINGDELEGATORDIR
                            $PINGDIRECTORYDIR
                            $PINGFEDERATEDIR
                            )

# Verifies directories contain content
for server_profile in "${server_profiles[@]}"
do
    if [ -z "$(ls -A $server_profile)" ]; then
        echo "$server_profile does not exist or does not contain any content!" | sed -e 's@./server-profile/@@'
        exit 1
    else
        echo "$server_profile directory does exist and contains content..." | sed -e 's@./server-profile/@@'
    fi
done

# Verifies adapters are included in solution
ADAPTERCOUNT=$(ls -1 server-profile/pingfederate/instance/server/default/deploy | wc -l)

if [ $ADAPTERCOUNT -ge "36" ]; then
    echo "Necessary adapters are included in PingFederate server profile..."
else
    echo "Necessary adapters are NOT included in PingFederate server profile!"
    exit 1
fi

# Verifies that adapter info for end-users are present in assets folder
CONNECTORINFOCOUNT=$(ls -1 ./assets | wc -l)

if [ $CONNECTORINFOCOUNT -gt "0" ]; then
    echo "Adapter information is included in solution..."
    exit 0
else
    echo "Adapter information is NOT included in solution!"
    exit 1
fi

#needed to support directory names with spaces
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
#get list of directories to check
ADAPTER_ASSETS=$(ls -d ./assets/*/ | sed -e 's/.$//')
#loop through and make sure content in each directory
for ADAPTER in $ADAPTER_ASSETS;do
if [ ! "$(ls -A $ADAPTER)" ]; then
        echo "$ADAPTER is empty!" | sed 's@./assets/@@g'
        exit 1
else
echo "$ADAPTER contains content" | sed 's@./assets/@@g'
fi
done
#set IFS back to OG value.
IFS=$SAVEIFS
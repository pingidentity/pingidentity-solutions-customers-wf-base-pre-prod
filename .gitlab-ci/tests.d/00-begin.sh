#!/bin/bash
# Script checks server profile directories are present and contain content

set +x
set -eo pipefail

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
        echo "$server_profile does not exist or does not contain any content" | sed -e 's@./server-profile/@@'
        exit 1
    else
        echo "$server_profile directory does exist and contains content" | sed -e 's@./server-profile/@@'
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
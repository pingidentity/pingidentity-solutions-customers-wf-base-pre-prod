#!/bin/bash

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

for server_profile in "${server_profiles[@]}"
do
    if [ -z "$(ls -A $server_profile)" ]; then
        echo "$server_profile does not exist or does not contain any content" | sed -e 's@./server-profile/@@'
        exit 1
    else
        echo "$server_profile directory does exist and contains content" | sed -e 's@./server-profile/@@'
    fi
done


ADAPTERCOUNT=$(ls -1 server-profile/pingfederate/instance/server/default/deploy | wc -l)

if [ $ADAPTERCOUNT != "36" ]; then
    echo "Not all adapters present, please add required adapters into PingFederate server profile!"
    exit 1
else
    echo "Necessary adapters are included in PingFederate server profile..."
fi

exit
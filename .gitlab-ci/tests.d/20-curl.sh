#! /bin/bash

SECONDS=0
SECONDSMAX=120

while [ "$USERSTATUS" != "200" ] & [ "$DIRSTATUS" != "200" ] & [ "$SAMLSTATUS" != "200" ] & [ "$OAUTHSTATUS" != "200" ]
do

    TIMEREMAINING=$(($SECONDSMAX-$SECONDS))
    if [[ $TIMEREMAINING -le 0 ]]; then
        exit 1
    fi
    
    echo "Validating that solution is running. $TIMEREMAINING more seconds allowed for test..."
    # Verify Sample Users were created successfully in PingDirectory
    USERSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:1443/directory/v1/uid=cdeacon,ou=People,dc=example,dc=com' \
    --header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "filter": "objectClass eq \"person\"",
    "searchScope": "wholeSubtree",
    "limit": 25,
    "includeAttributes": "*,_operationalAttributes",
    "excludeAttributes": "sn,isMemberOf"
    }')

    # Verify PingDirectory is setup in PingFederate as a Data Store
    DIRSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/dataStores/LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3' \
    --header 'X-XSRF-Header: PingFederate' \
    --header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')

    # Verify Sample SAML Connection is Setup in PingFederate
    SAMLSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/idp/spConnections?entityId=https%3A%2F%2Fhttpbin.org' \
    --header 'X-XSRF-Header: PingFederate' \
    --header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')

    #Verify OAuth setup in PingFederate
    OAUTHSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/oauth/clients' \
    --header 'X-XSRF-Header: PingFederate' \
    --header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')

    if [[ $OAUTHSTATUS -ne "200" ]]; then
        echo "Unable to determine OAuth Configuration in PingFederate..."
    else
        echo "OAuth Configuration is verified in PingFederate..."
    fi

    if [[ $SAMLSTATUS -ne "200" ]]; then
        echo "Unable to determine SAML Connection in PingFederate..."
    else
        echo "SAML Connection is verified in PingFederate..."
    fi

    if [[ $DIRSTATUS -ne "200" ]]; then
        echo "Unable to determine PingDirectory setup in PingFederate..."
    else
        echo "PingDirectory is verified in PingFederate..."
    fi

    if [[ $USERSTATUS -ne "200" ]]; then
        echo "Unable to find Sample User..."
    else
        echo "Sample User found in PingDirectory..."
    fi

    sleep 20

done

echo "API Calls were successful!"
exit
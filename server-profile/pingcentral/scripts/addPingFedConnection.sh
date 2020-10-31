curl --insecure --location --request POST 'https://localhost:9022/api/v1/environments' \
--header 'X-XSRF-Header: PASS' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGU=' \
--header 'Content-Type: application/json' \
--data-raw '{
            "description":"PingCentral to PingFed",
            "id": "PF",
            "idpSigningCertificate": null,
            "idpSigningCertificateName": null,
            "idpSigningCertificatePassword": null,
            "name": "PingFederate Connection",
            "paEnabled": false,
            "paHost": null,
            "paPort": 0,
            "paUsername": null,
            "paPassword": null,
            "paSkipVerification": true,
            "paVersion": null,
            "pfHost": "pingfederate",
            "pfPort": 9999,
            "pfUsername": "Administrator",
            "pfPassword": "2FederateM0re",
            "pfSkipVerification": false,
            "pfVersion": "10.1.0.8",
            "shielded": false,
            "shortCode": null
}'
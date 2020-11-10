#/bin/sh

while [ ! -f /opt/out/instance/conf/pingcentral.jwk ] ;
do
      sleep 2
done


#get encrypted value for instance
PWD_VAL=$(/opt/out/instance/bin/obfuscate.sh 2FederateM0re | tr '\n' ' ' | sed -e 's/.*OBF:JWE://' -e 's/ *$//')

#replace value in file to be loaded by mysql
cat /tmp/pingcentral_db/env_base_conf.sql | awk -v srch="PWD_VAL" -v repl="$PWD_VAL" '{ sub(srch,repl,$0); print $0 }' > /tmp/pingcentral_db/env_conf.sql
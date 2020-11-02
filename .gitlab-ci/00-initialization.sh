#!/bin/bash
set -xeo pipefail

REQUIRED_PKG="npm"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi
npm install newman
newman -v
pwd
env
echo "$USER"
type jq
type docker
docker info
type docker-compose
docker-compose version
type envsubst
envsubst --version
type git
git --version
type sed
sed --version
exit 0
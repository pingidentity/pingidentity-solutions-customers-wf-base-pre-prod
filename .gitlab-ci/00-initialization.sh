#!/bin/bash
set -xeo pipefail

cat /etc/os-release
which newman

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
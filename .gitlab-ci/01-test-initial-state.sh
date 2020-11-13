#!/bin/bash
# Sets variables along with starting solution

set +x
set -eo pipefail

[ ! -d "$HOME"/.pingidentity ] && mkdir "$HOME"/.pingidentity
[ ! -f "$HOME"/.pingidentity/devops ] && \
  cat <<DEVOPS > "$HOME"/.pingidentity/devops
PING_IDENTITY_ACCEPT_EULA=${PING_IDENTITY_ACCEPT_EULA:-YES}
PING_IDENTITY_DEVOPS_HOME=${PING_IDENTITY_DEVOPS_HOME:-$HOME/projects/devops}
PING_IDENTITY_DEVOPS_REGISTRY=${PING_IDENTITY_DEVOPS_REGISTRY:-docker.io/pingidentity}
PING_IDENTITY_DEVOPS_TAG=${PING_IDENTITY_DEVOPS_TAG:-latest}
DEVOPS

if [ ! -f .env ]; then
current_branch=${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-${CI_COMMIT_BRANCH:-$(git\
  branch --show-current)}}=
sed "s/<git_user>/$GITLAB_USER/;\
  s/<git_token>/$GITLAB_ACCESS_TOKEN/;\
  s/^SOLUTIONS_C360_PROFILE_BRANCH=.*$/SOLUTIONS_C360_PROFILE_BRANCH=$current_branch/" \
  .gitlab-ci/env-template-dev.txt >.env
fi

#log into pdsolutions docker account
docker login --username $DOCKER_UNAME --password $DOCKER_CRED

docker-compose up \
  --detach \
  --remove-orphans \
  --timeout 30 \
  --force-recreate

for script in .gitlab-ci/tests.d/*.sh; do
  echo "Executing $script..."
  bash $script || exit 1
done

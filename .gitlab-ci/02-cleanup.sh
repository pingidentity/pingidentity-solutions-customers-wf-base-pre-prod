#!/usr/bin/env bash
# Ping Identity DevOps - CI scripts
# Cleanup a docker environment

test -n "${VERBOSE}" && set -x

if test -z "${CI_COMMIT_REF_NAME}"
then
    CI_PROJECT_DIR="$( cd "$( dirname "${0}" )/.." || exit 97 ; pwd )"
    test -z "${CI_PROJECT_DIR}" && echo "Invalid call to dirname ${0}" && exit 97
fi

banner "Cleaning containers and images ( ciTag = ${ciTag} )"

# stop containers
_containers=$( docker container ls -q | sort | uniq )
# shellcheck disable=SC2086
test -n "${_containers}" && docker container stop ${_containers}

_containers=$( docker container ls -aq | sort | uniq )
# shellcheck disable=SC2086
test -n "${_containers}" && docker container rm -f ${_containers}

imagesToClean=$( docker image ls -qf "reference=*/*/*${ciTag}" | sort | uniq )
# shellcheck disable=SC2086
test -n "${imagesToClean}" && docker image rm -f ${imagesToClean}
imagesToClean=$( docker image ls -qf "dangling=true" )
# shellcheck disable=SC2086
test -n "${imagesToClean}" && docker image rm -f ${imagesToClean}

# clean all images if full clean is requested
if test "${1}" = "full"
then
    docker system prune -af
fi

# log out of docker account
docker logout

exit 0

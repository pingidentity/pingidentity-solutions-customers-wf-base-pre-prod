#!/bin/bash
set -euo pipefail

git remote add gh_location "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-c360.git"

if test -n "$CI_COMMIT_TAG"
then
    git push gh_location "$CI_COMMIT_TAG"
fi

git push gh_location HEAD:main

exit 0
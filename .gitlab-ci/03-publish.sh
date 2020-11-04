#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository

set -euo pipefail

git remote add gh_location "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"

if test -n "$CI_COMMIT_TAG"
then
    git push gh_location "$CI_COMMIT_TAG"
fi

git push gh_location HEAD:main

exit 0
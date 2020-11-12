#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository

set -x

GITLOCATION=$(git remote -v)
GITLOCATIONCHECK=$(echo "$GITLOCATION" | awk '/fetch/ && /push/')
if [[ "$GITLOCATIONCHECK" == *"pingidentity-solutions-wf360.git"* ]]; then
    echo "Git remote location already exists!"
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    git fetch --unshallow
    git push "$GITREMOTENAME" HEAD:main
else
    echo "Adding Git remote location..."
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    if [[ "$GITREMOTENAME" == "gh_location" ]]; then
        echo "Existing gh_location remote location found! Removing and adding proper git remote location..."
        git remote rm gh_location
        GITREMOTENAME="gh_location"
        echo "$GITREMOTENAME"
        git remote add $GITREMOTENAME "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"
        git fetch --unshallow
        git push $GITREMOTENAME HEAD:main
    else
        GITREMOTENAME="gh_location"
        echo "$GITREMOTENAME found! Removing and adding proper git remote location..."
        git remote add $GITREMOTENAME "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"
        git fetch --unshallow
        git push $GITREMOTENAME HEAD:main
    fi
fi

if test -n "$CI_COMMIT_TAG"
then
    echo "using $GITREMOTENAME..."
    git push $GITREMOTENAME $CI_COMMIT_TAG
fi
#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository

set -euo pipefail

GITLOCATION=$(git remote -v)
GITLOCATIONCHECK=$(echo "$GITLOCATION" | awk '/location/ && /push/')
if [[ "$GITLOCATIONCHECK" == *"pingidentity-solutions-wf360.git"* ]]; then
    echo "Git remote location already exists!"
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    git pull "$GITREMOTENAME"
    git push "$GITREMOTENAME" HEAD:main
else
    echo "Adding Git remote location..."
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    if [[ "$GITREMOTENAME" == "gh_location" ]]; then
        echo "$GITREMOTENAME found! Removing and adding proper git remote location..."
        git remote rm "$GITREMOTENAME"
        GITREMOTENAME="gh_location"
        git remote add "$GITREMOTENAME" "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"
        git pull "$GITREMOTENAME"
    fi
    git push "$GITREMOTENAME" HEAD:main

fi

if test -n "$CI_COMMIT_TAG"
then
    echo "using $GITREMOTENAME..."
    git pull "$GITREMOTENAME"
    git push "$GITREMOTENAME" "$CI_COMMIT_TAG"
fi

exit 0
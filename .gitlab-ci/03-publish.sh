#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository
​
set -euo pipefail
​
git config --global user.email 'pd-solutions@pingidentity.com'
git config --global user.name 'PingIdentity Solutions'
​
GITLOCATION=$(git remote -v)
GITLOCATIONCHECK=$(echo "$GITLOCATION" | awk '/location/ && /push/')
if [[ "$GITLOCATIONCHECK" == *"pingidentity-solutions-wf360.git"* ]]; then
    echo "Git remote location already exists!"
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    git push "$GITREMOTENAME" HEAD:main
else
    echo "Adding Git remote location..."
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    if [[ "$GITREMOTENAME" == "gh_location" ]]; then
        echo "$GITREMOTENAME found! Removing and adding proper git remote location..."
        git remote rm "$GITREMOTENAME"
        GITREMOTENAME="gh_location"
        git remote set-url "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"
    fi
    git pull "$GITREMOTENAME" HEAD:main
    git push "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git" HEAD:main
fi
​
if test -n "$CI_COMMIT_TAG"
then
    echo "using $GITREMOTENAME..."
    git push "$GITREMOTENAME" --tags "$CI_COMMIT_TAG"
fi
​
exit 0
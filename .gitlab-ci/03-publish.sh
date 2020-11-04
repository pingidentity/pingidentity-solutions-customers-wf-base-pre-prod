#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository

set -euo pipefail

GITHUBLOCATION=$(git remote -v)
GITHUBLOCATIONCHECK=$(echo "$GITHUBLOCATION" | awk '/github_location/ && /push/')
if [[ "$GITHUBLOCATIONCHECK" == *"pingidentity-solutions-wf360.git"* ]]; then
    echo "GitHub remote location already exists!"
    GITREMOTENAME=$(echo $GITHUBLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    #git push "$GITREMOTENAME" HEAD:main
else
    echo "Adding GitHub remote location..."
    echo $GITHUBLOCATION
#    GITREMOTENAME="gh_location"
#     git remote add "$GITREMOTENAME" "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-wf360.git"
#     git push "$GITREMOTENAME" HEAD:main
fi

# if test -n "$CI_COMMIT_TAG"
# then
#     git push "$GITREMOTENAME" "$CI_COMMIT_TAG"
#fi

exit 0
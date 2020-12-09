#!/bin/bash
# Pushes GitLab repository to public-facing GitHub (main branch) repository

set -x

#used for edge or early access releases or for main release
if [[ $CI_COMMIT_TAG == *"edge"* ]]; then
    BRANCH="edge"
elif [[ $CI_COMMIT_TAG == *"main"* ]]; then
    BRANCH="main"
else
    echo "Commit tag does not match expected version format. . ."
    exit 1   
fi

#check if this is workforce360 or customer360 before defining which to publish to.
if [[ $CI_PROJECT_PATH == "solutions/customer360" ]]; then
    GITHUB_REPO_NAME="pingidentity-solutions-customers-ciam-base-pre-prod.git"
elif [[ $CI_PROJECT_PATH == "solutions/workforce360" ]]; then
    GITHUB_REPO_NAME="pingidentity-solutions-customers-wf-base-pre-prod.git"
else
    #something is wrong and that's bad. Let's stop.
    echo "Repo name not found in Solutions project list"
    exit 1
fi


#check if the git remote value is already defined
GITLOCATION=$(git remote -v)
GITLOCATIONCHECK=$(echo "$GITLOCATION" | awk '/fetch/ && /push/')
#check if this is customer360/ciam or workforce360/wf-base
if [[ "$GITLOCATIONCHECK" == *"pingidentity-solutions-c360.git"* ]] || [[ "$GITLOCATIONCHECK" == *"ciam-base-pre-prod.git"* ]]; then
    echo "C360 Git remote location already exists!"
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    git fetch --unshallow
    git push --force "$GITREMOTENAME" HEAD:$BRANCH
elif [[ "$GITLOCATIONCHECK" == *"pingidentity-solutions-wf360.git"* ]] || [[ "$GITLOCATIONCHECK" == *"wf-base-pre-prod.git"* ]]; then
    echo "WF360 Git remote location already exists!"
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    echo "$GITREMOTENAME found... Using this to push to GitHub..."
    git fetch --unshallow
    git push --force $GITREMOTENAME HEAD:$BRANCH
else
    #if GITLOCATION was not defined, setting it below
    echo "Adding Git remote location..."
    GITREMOTENAME=$(echo $GITLOCATIONCHECK | awk '{print $1}')
    if [[ "$GITREMOTENAME" == "gh_location" ]]; then
        echo "Existing gh_location remote location found! Removing and adding proper git remote location..."
        git remote rm gh_location
        GITREMOTENAME="gh_location"
        echo "$GITREMOTENAME"
        git remote add $GITREMOTENAME "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/$GITHUB_REPO_NAME"
        git fetch --unshallow
        git push --force $GITREMOTENAME HEAD:$BRANCH
    #if really completely undefined setting everything
    else
        GITREMOTENAME="gh_location"
        echo "$GITREMOTENAME found! Removing and adding proper git remote location..."
        git remote add $GITREMOTENAME "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/$GITHUB_REPO_NAME"
        git fetch --unshallow
        git push --force $GITREMOTENAME HEAD:$BRANCH
    fi
fi

#sending that tag from GitLab to Github through some internet tubes if it's defined for this publish task.
if test -n "$CI_COMMIT_TAG"
then
    echo "using $GITREMOTENAME..."
    git push --force $GITREMOTENAME $CI_COMMIT_TAG
fi

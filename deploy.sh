#!/bin/bash

# Configuration - Use environment variables for sensitive data
# These variables should be set in your local environment or CI/CD system,
# NOT hardcoded in this script if it's committed to Git.
SERVER_USER="${DEPLOY_SERVER_USER}"
SERVER_IP="${DEPLOY_SERVER_IP}"
REMOTE_PATH="${DEPLOY_REMOTE_PATH}"

# Basic validation to ensure variables are set
if [ -z "${SERVER_USER}" ] || [ -z "${SERVER_IP}" ] || [ -z "${REMOTE_PATH}" ]; then
    echo "Error: Deployment environment variables (DEPLOY_SERVER_USER, DEPLOY_SERVER_IP, DEPLOY_REMOTE_PATH) are not set."
    echo "Please set them before running this script."
    exit 1
fi

echo "Building Hugo site..."
hugo --minify

if [ $? -eq 0 ]; then
    echo "Hugo build successful. Syncing files to server..."
    # The trailing slash on 'public/' is crucial for rsync to copy contents, not the folder itself
    rsync -avz --delete public/ "${SERVER_USER}@${SERVER_IP}:${REMOTE_PATH}"
    echo "Deployment complete!"
else
    echo "Hugo build failed. Deployment aborted."
fi


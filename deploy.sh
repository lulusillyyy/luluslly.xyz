#!/bin/bash

# Configuration
SERVER_USER="lulu"         # Your SSH username on the server
SERVER_IP="ptolemy"          # Your server's IP address or domain
REMOTE_PATH="/var/www/lulu/" # The directory on the server where your Hugo public/ folder contents will go

echo "Building Hugo site..."
hugo --minify

if [ $? -eq 0 ]; then
    echo "Hugo build successful. Syncing files to server..."
    rsync -avz --delete public/ ${SERVER_USER}@${SERVER_IP}:${REMOTE_PATH}
    echo "Deployment complete!"
else
    echo "Hugo build failed. Deployment aborted."
fi

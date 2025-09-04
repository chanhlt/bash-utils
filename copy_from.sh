#!/bin/bash

# Check arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: copy_from  <remote_host> <remote_file> [remote_user]"
    exit 1
fi

REMOTE_FILE=$2
REMOTE_HOST=$1
REMOTE_USER=${3:-soxes}  # Default to 'soxes' if not provided

# Extract password from Keychain
PASSWORD=$(security find-generic-password -s "$REMOTE_HOST" -a "$REMOTE_USER" -w 2>/dev/null)
if [ -z "$PASSWORD" ]; then
    echo "Error: Unable to retrieve password from Keychain for $REMOTE_USER@$REMOTE_HOST"
    exit 2
fi

# Use SCP with SSH pass
sshpass -p "$PASSWORD" scp "$REMOTE_USER@$REMOTE_HOST:$REMOTE_FILE" .

if [ $? -eq 0 ]; then
    echo "File successfully copied from $REMOTE_USER@$REMOTE_HOST:~/"
else
    echo "Error: File transfer failed."
    exit 3
fi

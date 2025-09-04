#!/bin/bash

# Check arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: copy_to <local_file> <remote_host> [remote_user]"
    exit 1
fi

LOCAL_FILE=$1
REMOTE_HOST=$2
REMOTE_USER=${3:-soxes}  # Default to 'soxes' if not provided

# Extract password from Keychain
PASSWORD=$(security find-generic-password -s "$REMOTE_HOST" -a "$REMOTE_USER" -w 2>/dev/null)
if [ -z "$PASSWORD" ]; then
    echo "Error: Unable to retrieve password from Keychain for $REMOTE_USER@$REMOTE_HOST"
    exit 2
fi

# Use SCP with SSH pass
sshpass -p "$PASSWORD" scp "$LOCAL_FILE" "$REMOTE_USER@$REMOTE_HOST":~/

if [ $? -eq 0 ]; then
    echo "File successfully copied to $REMOTE_USER@$REMOTE_HOST:~/"
else
    echo "Error: File transfer failed."
    exit 3
fi

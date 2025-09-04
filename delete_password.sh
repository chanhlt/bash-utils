#!/bin/bash

# Usage: ./delete_password.sh <username> <server>
# Example: ./delete_password.sh alice myserver.com

user="$1"
server="$2"

if [[ -z "$user" || -z "$server" ]]; then
  echo "Usage: $0 <username> <server>"
  exit 1
fi

# Delete from Keychain
security delete-generic-password -a "$user" -s "$server"

if [[ $? -eq 0 ]]; then
  echo "Password for $user@$server deleted from Keychain."
else
  echo "No password entry found for $user@$server, or deletion failed."
  exit 1
fi

#!/bin/bash

# Usage: ./add_password.sh <username> <server>
# Example: ./add_password.sh alice myserver.com

user="$1"
server="$2"

if [[ -z "$user" || -z "$server" ]]; then
  echo "Usage: $0 <username> <server>"
  exit 1
fi

# Prompt for password securely
read -s -p "Enter password for $user@$server: " password
echo

# Add to Keychain
security add-generic-password -a "$user" -s "$server" -w "$password" -U

if [[ $? -eq 0 ]]; then
  echo "Password stored in Keychain for $user@$server."
else
  echo "Failed to store password."
  exit 1
fi

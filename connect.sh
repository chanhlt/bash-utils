#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide server IP or domain name." >&2
  exit 1
fi

USER=${2:-soxes}
HOST=$1

ssh_login $USER $HOST

#!/bin/bash
set -e

# Docker Container Management Script
# Usage: ./deploy.sh [service-name]
# If no service name is provided, a full rolling update will be performed.

SERVICE=$1

if [ "$SERVICE" = "list" ]; then
  echo "[INFO] Services:"
  docker compose config --services
  exit 0
fi


if [ -z "$SERVICE" ]; then
  echo "[INFO] Since the service name is not specified, a full rolling update will be performed."
  SERVICES=$(docker compose config --services)
  for SVC in $SERVICES; do
    echo "[INFO] Rolling service update in progress... ($SVC)"
    docker compose up -d --build $SVC
  done
else
  echo "[INFO] Rolling update only specific services ($SERVICE)."
  docker compose up -d --build $SERVICE
fi

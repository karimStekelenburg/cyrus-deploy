#!/bin/bash
set -e

# Fix SSH directory permissions if mounted
if [ -d "$HOME/.ssh" ]; then
    chmod 700 "$HOME/.ssh"
    # Only chmod files if they exist
    if ls "$HOME/.ssh"/* 1> /dev/null 2>&1; then
        chmod 600 "$HOME/.ssh"/*
    fi
fi

# Configure git safe directory for worktrees
git config --global --add safe.directory /app/worktrees

# Load environment from ~/.cyrus/.env if it exists
if [ -f "$HOME/.cyrus/.env" ]; then
    set -a
    source "$HOME/.cyrus/.env"
    set +a
fi

# Cyrus binds to localhost only, so we use socat to proxy external traffic
EXTERNAL_PORT="${CYRUS_SERVER_PORT:-3456}"
INTERNAL_PORT=3457

# Override CYRUS_SERVER_PORT to use internal port
export CYRUS_SERVER_PORT="$INTERNAL_PORT"

# Print startup message
echo "Starting Cyrus..."
echo "  CYRUS_BASE_URL: ${CYRUS_BASE_URL:-not set}"
echo "  External port: $EXTERNAL_PORT (via socat)"
echo "  Internal port: $INTERNAL_PORT (Cyrus localhost)"

# Start socat to forward external traffic to localhost
echo "Starting socat proxy: 0.0.0.0:$EXTERNAL_PORT -> localhost:$INTERNAL_PORT"
socat TCP-LISTEN:$EXTERNAL_PORT,fork,reuseaddr TCP:localhost:$INTERNAL_PORT &

# Execute cyrus command or pass through arguments
if [ $# -eq 0 ]; then
    exec cyrus
else
    exec "$@"
fi

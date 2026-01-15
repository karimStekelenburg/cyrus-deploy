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

# Print startup message
echo "Starting Cyrus..."
echo "  CYRUS_BASE_URL: ${CYRUS_BASE_URL:-not set}"
echo "  CYRUS_SERVER_PORT: ${CYRUS_SERVER_PORT:-not set}"

# Execute cyrus command or pass through arguments
if [ $# -eq 0 ]; then
    exec cyrus
else
    exec "$@"
fi

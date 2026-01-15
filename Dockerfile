# Cyrus AI Agent Dockerfile
# Production-ready image for self-hosting Cyrus AI

FROM node:20-slim

# Install system dependencies in a single layer for caching
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    jq \
    curl \
    openssh-client \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Install cyrus-ai globally
RUN npm install -g cyrus-ai

# Create required directories
RUN mkdir -p /app/worktrees /root/.cyrus

# Set working directory
WORKDIR /app

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose Cyrus server port
EXPOSE 3456

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]

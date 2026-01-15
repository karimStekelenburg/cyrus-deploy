# Cyrus Deployment for void

Docker deployment configuration for [Cyrus](https://github.com/ceedaragents/cyrus) AI agent on void home server via Dokploy.

## Prerequisites

1. **Linear OAuth Application** - Create at Linear Settings → API → OAuth Applications
2. **Public URL** - Configure Tailscale Funnel or Cloudflare Tunnel
3. **Anthropic API Key** - From console.anthropic.com

## Quick Start

```bash
# 1. Copy and configure environment
cp .env.template .env
# Edit .env with your credentials

# 2. Create data directories
mkdir -p data/cyrus data/worktrees

# 3. Build and start
docker-compose up -d

# 4. Authorize with Linear (first time only)
docker exec -it cyrus cyrus self-auth

# 5. Add repositories
docker exec -it cyrus cyrus self-add-repo https://github.com/yourorg/yourrepo.git
```

## Tailscale Funnel Setup

```bash
# On void server
tailscale funnel --bg 3456
# This provides: https://void.taile9c137.ts.net
```

## Files

- `Dockerfile` - Container image definition
- `docker-compose.yml` - Service configuration with Traefik
- `entrypoint.sh` - Container startup script
- `.env.template` - Environment variable template

## Traefik Routing

Access at: `http://cyrus.void` (internal) or via Tailscale Funnel (external)

## Linear Project

Tracked in: [Cyrus Deployment](https://linear.app/k3msh/project/cyrus-deployment-459191d37cbc)

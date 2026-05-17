# ObservAI Self-Hosted

Official deployment repository for ObservAI in self-hosted environments.

This repository provides the production-aware installation layer for the application stack
(`observai-api` + `observai-web`) and the required dependencies (PostgreSQL, Redis,
reverse proxy examples, Kubernetes manifests and Helm chart).

## Why this repository

You only use this repository to run ObservAI in your infrastructure.

It does **not** contain application source code. It contains:

- Docker Compose stacks (dev/production)
- Reverse proxy examples
- Kubernetes manifests
- Helm chart
- Bootstrap scripts
- Setup and operation documentation

The application services themselves live in:

- `https://github.com/guferreira1/observai-api`
- `https://github.com/guferreira1/observai-web`

## Documentation

- [English documentation](docs/en/README.md)
- [Documentação em português](docs/pt-br/README.md)

## Deployment paths

- Docker Compose: primary path for local use and small/medium production
- Docker Compose + reverse proxy: recommended for production
- Kubernetes manifests: advanced manual path
- Helm: advanced, reusable path for Kubernetes

## Quick start

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
docker compose up -d
```

Open:

- Web: `http://localhost:3000`
- API through Web proxy: `http://localhost:3000/api/observai/health`
- API direct health check: `http://localhost:8080/healthz`

## What docs cover

The bilingual documentation covers:

- installation
- configuration
- production hardening
- DNS and reverse proxy
- backups and restore
- upgrades
- Kubernetes + Helm
- troubleshooting

## Repository map

```text
.
├── docker-compose.yml            # Base local stack
├── docker-compose.prod.yml       # Production stack with nginx
├── docker-compose.override.example.yml
├── .env.example
├── docs/
├── nginx/                       # nginx sample
├── traefik/                     # Traefik compose sample
├── k8s/                         # Base Kubernetes manifests
├── helm/                        # Helm chart
└── scripts/
    ├── backup-postgres.sh
    ├── restore-postgres.sh
    └── generate-secrets.sh
```

## Compatibility note

`observai-api` and `observai-web` must be reachable by the network model defined in your stack.
For a browser-safe model, keep the recommended `/api/observai` path routing rule:

- `https://observai.example.com` -> Web
- `https://observai.example.com/api/observai` -> API access path

This is the default path model in:

- `.env.example`
- `docker-compose.prod.yml`
- `nginx/nginx.conf`
- `traefik/docker-compose.traefik.yml`
- Kubernetes manifests
- Helm ingress/templates

## License

This project is licensed under the MIT License.

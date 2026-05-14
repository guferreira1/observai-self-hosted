<div align="center">

# ObservAI Self-Hosted

**Official self-hosted deployment stack for ObservAI.**

Run ObservAI with Docker Compose, reverse proxy examples, Kubernetes manifests and Helm.

</div>

---

## About

ObservAI Self-Hosted is the operational repository for running ObservAI outside a managed SaaS environment.

This repository does not contain the application source code. It contains the deployment stack, examples, scripts and documentation needed to install, configure, operate and upgrade ObservAI in self-hosted environments.

ObservAI is composed of two main application services:

- `observai-api`: backend API responsible for business rules, providers, LLM integrations, analysis execution, persistence and security.
- `observai-web`: Next.js frontend responsible for user experience, configuration screens, analysis workspace, evidence viewer and AI chat.

This repository provides the deployment layer that runs those services together with their required infrastructure.

---

## Deployment options

| Mode | Status | Recommended for |
|---|---|---|
| Docker Compose | Primary | Local testing, homelab, POCs and small production environments |
| Docker Compose + reverse proxy | Recommended production path | VM-based production with custom domain and HTTPS |
| Kubernetes manifests | Advanced | Teams that want direct Kubernetes YAML examples |
| Helm Chart | Advanced | Production Kubernetes deployments |

---

## Quick start

Requirements:

- Docker
- Docker Compose

Clone this repository:

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
```

Create your environment file:

```bash
cp .env.example .env
```

Start the stack:

```bash
docker compose up -d
```

Open ObservAI Web:

```txt
http://localhost:3000
```

ObservAI API will be available at:

```txt
http://localhost:8080
```

---

## Default services

The default Docker Compose stack includes:

- ObservAI Web
- ObservAI API
- PostgreSQL
- Redis

Future production examples may include:

- Nginx
- Traefik
- Caddy
- external PostgreSQL
- external Redis
- Kubernetes Ingress
- Helm-based installation

---

## Image registries

The default examples are prepared for Docker Hub images:

```txt
observai/observai-api
observai/observai-web
```

The image names are configurable through `.env`, so users can switch to another registry when needed, such as GHCR or a private registry.

Example:

```env
OBSERVAI_API_IMAGE=observai/observai-api
OBSERVAI_WEB_IMAGE=observai/observai-web
OBSERVAI_API_VERSION=v0.1.0
OBSERVAI_WEB_VERSION=v0.1.0
```

---

## Recommended production model

For production with a custom domain, the recommended model is a single public domain with the API exposed behind `/api` through a reverse proxy:

```txt
https://observai.example.com      -> ObservAI Web
https://observai.example.com/api  -> ObservAI API
```

This model simplifies browser security, avoids most CORS issues and keeps the self-hosted setup easier to operate.

Recommended production environment values:

```env
OBSERVAI_PUBLIC_URL=https://observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api
OBSERVAI_ALLOWED_ORIGINS=https://observai.example.com
TRUST_PROXY=true
```

DNS, TLS certificates and reverse proxy configuration are handled by the user's infrastructure. ObservAI only needs to be configured with the public URLs and allowed origins.

---

## Repository structure

```txt
.
├── docker-compose.yml
├── docker-compose.prod.yml
├── docker-compose.override.example.yml
├── .env.example
├── docs/
├── nginx/
├── traefik/
├── k8s/
├── helm/
├── scripts/
└── .codex/
```

---

## Responsibilities

### ObservAI API

The backend owns:

- authentication and authorization;
- provider configuration;
- LLM provider configuration;
- secure credential handling;
- analysis execution;
- evidence collection;
- chat sessions;
- persistence;
- API security;
- health checks;
- logs, metrics and tracing.

### ObservAI Web

The frontend owns:

- user interface;
- dashboard;
- provider setup screens;
- LLM setup screens;
- analysis workspace;
- evidence viewer;
- trace insights;
- AI chat;
- accessibility;
- frontend state and API consumption.

### ObservAI Self-Hosted

This repository owns:

- Docker Compose installation;
- production examples;
- reverse proxy examples;
- Kubernetes examples;
- Helm Chart;
- environment variable documentation;
- backup and restore scripts;
- upgrade documentation;
- troubleshooting documentation.

---

## Documentation

Start here:

- `docs/installation.md`
- `docs/configuration.md`
- `docs/production.md`
- `docs/dns-and-reverse-proxy.md`
- `docs/kubernetes.md`
- `docs/backup-restore.md`
- `docs/upgrade.md`
- `docs/troubleshooting.md`

---

## Current status

This repository is in its initial setup phase.

The Docker Compose stack is the first-class installation path. Kubernetes and Helm files are provided as an advanced starting point and should evolve with real production usage.

---

## License

This project is licensed under the MIT License.

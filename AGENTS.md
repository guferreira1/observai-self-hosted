# AGENTS.md

## Project

ObservAI Self-Hosted is the operational repository for installing and running ObservAI in self-hosted environments.

This repository contains Docker Compose files, production examples, reverse proxy examples, Kubernetes manifests, Helm chart, scripts and documentation.

## Main goal

Keep the self-hosted experience simple, safe and production-aware.

The default installation path must be Docker Compose.

Kubernetes and Helm must be available as advanced deployment options.

## Responsibilities

This repository owns:

- installation docs;
- configuration docs;
- Docker Compose stack;
- reverse proxy examples;
- Kubernetes examples;
- Helm chart;
- backup and restore scripts;
- upgrade docs;
- troubleshooting docs.

This repository must not contain application business logic.

## Safety rules

Do not commit real secrets.

Do not commit real credentials.

Do not use real tokens in examples.

Use safe placeholders such as `change-me` or `observai.example.com`.

## Operational rules

Prefer explicit versions over `latest` in production examples.

Keep Docker Hub as the default registry while allowing alternative registries through variables.

Keep custom domain support proxy-friendly with the recommended `/api` routing model.

## Git safety

Do not work directly on `main` unless the repository is being initialized and has no commits.

Use dedicated branches for changes.

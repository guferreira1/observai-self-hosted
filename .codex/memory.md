# Codex memory

Do not store secrets, tokens, passwords or sensitive values here.

## 2026-05-14 - Initial self-hosted structure

Summary:

Created the initial self-hosted repository structure for ObservAI.

Decisions:

- Docker Compose is the primary installation path.
- Docker Hub is the default registry in examples.
- Image names are configurable through `.env`.
- Production recommendation uses one domain with `/api` proxying to the backend.
- Kubernetes manifests and Helm are advanced deployment paths.

Pending:

- Validate against real `observai-api` and `observai-web` Docker images when available.
- Adjust health check paths if the applications expose different endpoints.
- Add CI validation for YAML and Helm templates.

Validation:

- Documentation and deployment scaffold only.

# Docker Hub (English)

The default images are:

- `observai/observai-api`
- `observai/observai-web`

## Registry alternatives

You can switch repository host in `.env` without changing the deployment files:

```env
OBSERVAI_API_IMAGE=ghcr.io/guferreira1/observai-api
OBSERVAI_WEB_IMAGE=ghcr.io/guferreira1/observai-web
```

Private registry example:

```env
OBSERVAI_API_IMAGE=registry.example.com/observai/observai-api
OBSERVAI_WEB_IMAGE=registry.example.com/observai/observai-web
```

Then update locally:

```bash
docker compose pull
docker compose up -d
```

For private registries, log in before pulling.

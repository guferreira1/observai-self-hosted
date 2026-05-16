# Docker Hub (Português)

Imagens padrão:

- `observai/observai-api`
- `observai/observai-web`

## Trocar registry

Altere no `.env` sem editar manifestos:

```env
OBSERVAI_API_IMAGE=ghcr.io/guferreira1/observai-api
OBSERVAI_WEB_IMAGE=ghcr.io/guferreira1/observai-web
```

Exemplo de registry privado:

```env
OBSERVAI_API_IMAGE=registry.example.com/observai/observai-api
OBSERVAI_WEB_IMAGE=registry.example.com/observai/observai-web
```

Recarregue as imagens:

```bash
docker compose pull
docker compose up -d
```

Para registry privado, faça login antes do pull.

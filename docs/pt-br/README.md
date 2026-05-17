# Documentação Self-Hosted do ObservAI

Este repositório reúne os artefatos para executar o ObservAI em ambiente
self-hosted:

- `observai-api` (backend)
- `observai-web` (painel web)
- PostgreSQL e Redis
- exemplos de Docker Compose e Kubernetes

Os repositórios de código-fonte da aplicação ficam em:

- `observai-api`
- `observai-web`

## Leitura recomendada

- [Instalação](installation.md)
- [Configuração](configuration.md)
- [Guia de produção](production.md)
- [DNS e proxy reverso](dns-and-reverse-proxy.md)
- [Kubernetes](kubernetes.md)
- [Registry Docker Hub](docker-hub.md)
- [Upgrade](upgrade.md)
- [Solução de problemas](troubleshooting.md)
- [Backup e restore](backup-restore.md)

## Idiomas da documentação

- Inglês: `docs/en/*`
- Português: `docs/pt-br/*`

## Arquitetura rápida

### Ambiente local (padrão)

```txt
Browser
  -> observai-web (HTTP 3000)
  -> /api/observai/*
  -> proxy interno do Next.js
  -> observai-api (HTTP 8080)
  -> PostgreSQL (estado)
  -> Redis (fila/cache)
```

### Produção com proxy reverso

```txt
https://observai.example.com                  -> observai-web
https://observai.example.com/api/observai     -> caminho de acesso da API
```

Use `NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai` para manter as chamadas do navegador no mesmo domínio e compatíveis com o proxy do Web.

## Inicialização mínima

```bash
git clone https://github.com/guferreira1/observai-self-hosted.git
cd observai-self-hosted
cp .env.example .env
docker compose up -d
```

Acesso:

- `http://localhost:3000` (web)
- `http://localhost:3000/api/observai/health` (API via proxy do Web)
- `http://localhost:8080/healthz` (readiness direto da API)

## Quando usar este repositório

Use este repositório para implantação e operação (proxy, Kubernetes, upgrade,
backup/restore e troubleshooting).

Para detalhes do contrato e da API, use `observai-api`.

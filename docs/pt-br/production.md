# Produção (Português)

## Arquitetura recomendada

Use um domínio único e mantenha as chamadas da API no caminho do proxy do Web:

```txt
https://observai.example.com                  -> observai-web
https://observai.example.com/api/observai     -> caminho de acesso da API via observai-web
observai-web                                  -> observai-api:8080
```

Esse padrão reduz CORS, centraliza TLS e mantém o frontend compatível com o proxy interno do Next.js.

## Checklist pré-produção

- Use tags fixas de imagem (`v0.1.x`) e evite `latest`.
- Execute `OBSERVAI_MIGRATE_ON_START=true` na primeira inicialização.
- Use `NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai`.
- Use `OBSERVAI_API_URL=http://observai-api:8080` quando Web e API estiverem na mesma rede Docker/Kubernetes.
- Use valores fortes para `OBSERVAI_JWT_SECRET` e `OBSERVAI_ENCRYPTION_KEY`.
- Mantenha PostgreSQL e Redis com credenciais fortes.
- Não exponha portas de DB/Redis à internet.
- Valide backup antes de liberar tráfego.
- Garanta observabilidade de `health`, `readyz` e logs.

Segurança:

- HTTPS obrigatório com redirect de HTTP.
- Política `Content-Security-Policy`, `X-Frame-Options`,
  `Referrer-Policy` e `Strict-Transport-Security`.
- Proteja cabeçalhos `Host` e `X-Forwarded-*` no proxy.
- Mantenha cabeçalhos de sessão/segurança conforme sua política interna.

## Exemplo de `.env` para produção

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
NEXT_PUBLIC_APP_ENV=production
LOG_LEVEL=info

OBSERVAI_ENV=self-hosted
OBSERVAI_MODE=local
OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000
OBSERVAI_MIGRATE_ON_START=true
OBSERVAI_MIGRATIONS_DIR=/app/migrations
```

## Inicialização com `docker-compose.prod.yml`

```bash
cp .env.example .env
docker compose -f docker-compose.prod.yml up -d
```

`docker-compose.prod.yml` mantém portas internas e delega exposição pública para o
`nginx`. Se preferir HTTPS com certificados automáticos, use
`traefik/docker-compose.traefik.yml`.

## Proxy reverso

- Force HTTPS com HSTS.
- Mantenha `/api/observai` roteado para o serviço Web, a menos que você configure rewrite explícito para a raiz da API.
- Encaminhe corretamente `Host`, `X-Forwarded-*` e protocolo.

## Implantação

1. Teste em staging com volume de tráfego similar.
2. Realize setup inicial, login e configuração básica.
3. Valide:
   - `GET /health`
   - `GET /healthz`
   - `GET /readyz`
   - `GET /api/observai/health`
4. Execute restore de backup e validação de rota.
5. Atualize DNS apenas quando todos os checks estiverem estáveis.

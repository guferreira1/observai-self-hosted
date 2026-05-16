# Produção (Português)

## Arquitetura recomendada

Use um domínio único com roteamento de API em `/api`:

```txt
https://observai.example.com      -> observai-web
https://observai.example.com/api  -> observai-api
```

Esse padrão reduz CORS e simplifica TLS.

## Checklist pré-produção

- Use tags fixas de imagem (`v0.1.x`) e evite `latest`.
- Execute `OBSERVAI_MIGRATE_ON_START=true` na primeira inicialização.
- Use segredos fortes e não reutilize entre ambientes.
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
NEXT_PUBLIC_OBSERVAI_API_URL=/api
NEXT_PUBLIC_APP_ENV=production
LOG_LEVEL=info

OBSERVAI_API_PORT=8080
OBSERVAI_WEB_PORT=3000
OBSERVAI_MIGRATE_ON_START=true
```

## Inicialização com `docker-compose.prod.yml`

```bash
cp .env.example .env
docker compose -f docker-compose.prod.yml up -d
```

`docker-compose.prod.yml` mantém portas internas e delega exposição pública para o
`nginx`. Se preferir HTTPS com certificados automáticos, use
`traefik/docker-compose.traefik.yml`.

## Implantação

1. Teste em staging com volume de tráfego similar.
2. Realize setup inicial, login e configuração básica.
3. Valide:
   - `GET /health`
   - `GET /healthz`
   - `GET /readyz`
4. Execute restore de backup e validação de rota.
5. Atualize DNS apenas quando todos os checks estiverem estáveis.

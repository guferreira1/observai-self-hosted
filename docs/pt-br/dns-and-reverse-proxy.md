# DNS e Proxy Reverso (Português)

O projeto self-hosted não cria DNS, certificados nem WAF.
Esses recursos devem ser configurados fora do repositório.

## Modelo de domínio

```txt
https://observai.example.com                  -> ObservAI Web
https://observai.example.com/api/observai     -> caminho de acesso da API via ObservAI Web
```

O navegador deve chamar `/api/observai`. O container Web encaminha as requisições para a API usando `OBSERVAI_API_URL`.

## Nginx (`docker-compose.prod.yml`)

No compose de produção o Nginx faz:

- `location /` -> `observai-web:3000`
- `location /api/observai/` -> `observai-api:8080/`

O frontend deve usar:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

O exemplo de Nginx envia `/api/observai/*` direto para a raiz da API. Outros proxies podem rotear `/api/observai/*` para `observai-web:3000` e deixar o proxy interno do Next.js encaminhar para a API.

## Traefik (`traefik/docker-compose.traefik.yml`)

O Traefik roteia o modelo exposto ao navegador para o serviço Web:

- Web: `Host(${OBSERVAI_DOMAIN})`
- Caminho da API: `Host(${OBSERVAI_DOMAIN}) && PathPrefix(/api/observai)` -> `observai-web:3000`

Defina:

```env
OBSERVAI_DOMAIN=observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api/observai
OBSERVAI_API_URL=http://observai-api:8080
```

## DNS e certificados

1. Criar registro:

```txt
observai.example.com -> IP_PUBLICO
```

2. Publicar HTTPS com seu provedor de certificados preferido (Let's Encrypt,
   ACME, certificado gerenciado, etc.).

3. Não disponibilize `/api/observai` sem TLS.

## Validação

```bash
curl -I https://observai.example.com/
curl -I https://observai.example.com/api/observai/health
curl -I https://observai.example.com/api/observai/v1/setup/status
```

Resposta esperada: `200` ou código padrão dos endpoints de health/setup.

# DNS e Proxy Reverso (Português)

O projeto self-hosted não cria DNS, certificados nem WAF.
Esses recursos devem ser configurados fora do repositório.

## Modelo de domínio

```txt
https://observai.example.com      -> ObservAI Web
https://observai.example.com/api  -> ObservAI API
```

## Nginx (`docker-compose.prod.yml`)

No compose de produção o Nginx faz:

- `location /` -> `observai-web:3000`
- `location /api/` -> `observai-api:8080`

O frontend deve usar:

```env
NEXT_PUBLIC_OBSERVAI_API_URL=/api
```

## Traefik (`traefik/docker-compose.traefik.yml`)

Regras:

- Web: `Host(${OBSERVAI_DOMAIN})`
- API: `Host(${OBSERVAI_DOMAIN}) && PathPrefix(/api)`

Defina:

```env
OBSERVAI_DOMAIN=observai.example.com
```

## DNS e certificados

1. Criar registro:

```txt
observai.example.com -> IP_PUBLICO
```

2. Publicar HTTPS com seu provedor de certificados preferido (Let's Encrypt,
   ACME, certificado gerenciado, etc.).

3. Não disponibilize `/api` sem TLS.

## Validação

```bash
curl -I https://observai.example.com/
curl -I https://observai.example.com/api/health
curl -I https://observai.example.com/api/v1/setup/status
```

Resposta esperada: `200` (ou código padrão do endpoint).

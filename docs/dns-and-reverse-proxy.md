# DNS and reverse proxy

ObservAI does not manage DNS, TLS or reverse proxy configuration internally.

The application only needs to receive the correct public URL and API URL through environment variables.

## Recommended domain model

Use one public domain:

```txt
https://observai.example.com      -> ObservAI Web
https://observai.example.com/api  -> ObservAI API
```

Recommended environment:

```env
OBSERVAI_PUBLIC_URL=https://observai.example.com
NEXT_PUBLIC_OBSERVAI_API_URL=/api
OBSERVAI_ALLOWED_ORIGINS=https://observai.example.com
TRUST_PROXY=true
```

## DNS

Create an A record pointing to your server IP:

```txt
observai.example.com -> SERVER_PUBLIC_IP
```

If using a cloud load balancer, use the DNS target provided by the cloud provider.

## Reverse proxy responsibility

The reverse proxy routes traffic:

```txt
/    -> observai-web:3000
/api -> observai-api:8080
```

Supported examples:

- Nginx
- Traefik
- Caddy
- Kubernetes Ingress
- Cloudflare in front of any of those

## Cloudflare

Cloudflare can be used for DNS, proxying and TLS.

ObservAI does not need Cloudflare-specific logic for the basic self-hosted setup.

The application should only be configured with the public URL and allowed origins.

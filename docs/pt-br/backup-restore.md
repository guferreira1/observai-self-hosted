# Backup e Restore (Português)

O PostgreSQL é a fonte de verdade para configuração e histórico do ObservAI.
Redis é estado operacional e cache; trate conforme política da sua operação.

## Backup

```bash
./scripts/backup-postgres.sh
```

Formato padrão:

```txt
backups/observai-postgres-YYYYMMDD-HHMMSS.dump
```

## Restore

```bash
./scripts/restore-postgres.sh backups/observai-postgres-YYYYMMDD-HHMMSS.dump
```

Antes de liberar tráfego:

- Validar `readyz`
- Confirmar fluxo de login e admin
- Executar ao menos uma criação de análise

## Recomendações operacionais

- Armazene backups fora da máquina principal.
- Criptografe dados sensíveis.
- Teste restore com periodicidade no staging.
- Em managed DB, priorize snapshots nativos e mantenha scripts locais como
  fallback.
- Defina retenção e rotação consistentes.

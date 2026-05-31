# Workflow: create-issues

Comando: `/project-manager create-github-issues`

## Objetivo

Publicar o backlog no GitHub **de forma real**: conectar ao repositório, aplicar labels corretas, criar issues na ordem hierárquica e registrar mapeamento local → `#N`.

**O agente deve executar os comandos.** Não entregar apenas Markdown se `gh` ou GitHub MCP estiverem disponíveis.

---

## Pré-requisitos

- Backlog gerado (`create-backlog`)
- Conexão GitHub validada — [github-connect.md](github-connect.md)

---

## Fase 0 — Conectar ao GitHub

Executar workflow completo de [github-connect.md](github-connect.md):

```bash
# 1. Detectar repo
REPO=$(bash scripts/verify-github.sh 2>/dev/null | tail -1)

# 2. Bootstrap labels
bash scripts/bootstrap-labels.sh "$REPO"
```

Se `verify-github.sh` falhar → orientar `gh auth login` e retry.

---

## Fase 1 — Gerar corpos das issues

Para cada work item do backlog:

1. Aplicar template de `templates/`
2. Salvar em `.project-manager/issues/{local_id}.md`
3. Incluir metadados no topo:

```markdown
<!-- project-manager: type=feature | epic=E1 | points=5 | complexity=M | local-id=F1.1 -->
```

4. Títulos padronizados:

| Tipo | Formato |
|------|---------|
| Epic | `[Epic] Título` |
| Feature | `[Feature] Título` |
| Task | `[Task] Título` |
| Bug | `[Bug] Título` |
| Tech Debt | `[Tech Debt] Título` |

---

## Fase 2 — Calcular labels (obrigatório)

Para **cada** item, montar array `labels` seguindo regras determinísticas:

### 1. Tipo (obrigatório)

```
epic → ["epic"]
feature → ["feature"]
task → ["task"]
bug → ["bug"]
technical-debt → ["technical-debt"]
```

### 2. Prioridade (exatamente uma)

```
P0, P1, high → high-priority
P2, medium   → medium-priority
P3, low      → low-priority
```

Bugs: mapear severidade → prioridade:

| Severidade | Label prioridade |
|------------|------------------|
| critical, high | high-priority |
| medium | medium-priority |
| low | low-priority |

### 3. Estado (exatamente uma)

```
blocked_by_local não vazio E dependência ainda não criada/fechada → blocked
caso contrário → ready
```

**Nunca** usar `ready` e `blocked` juntos.

### 4. Módulo (opcional, zero ou uma)

| Módulo SaaS | Label |
|-------------|-------|
| Authentication, Authorization | auth |
| Billing, Payments, Stripe | billing |
| Notifications | notifications |
| Administration | admin |
| Infrastructure, CI/CD, Monitoring | infra |

### Exemplo final

```json
"labels": ["feature", "high-priority", "ready", "auth"]
```

---

## Fase 3 — Gerar manifest.json

Criar `.project-manager/manifest.json` na **ordem de criação**:

```
1. Epics (E*)
2. Technical Debt (TD*)
3. Features (F*)
4. Tasks (T*)
5. Bugs (B*)
```

Formato (ver [config/manifest.example.json](../config/manifest.example.json)):

```json
{
  "repo": "owner/repo",
  "milestone": "r1-mvp",
  "issues": [
    {
      "local_id": "E1",
      "type": "epic",
      "title": "[Epic] Autenticação e gestão de sessão",
      "body_file": ".project-manager/issues/E1.md",
      "labels": ["epic", "high-priority", "ready"],
      "priority": "high",
      "module": null,
      "blocked_by_local": [],
      "parent_local": null
    }
  ]
}
```

Validar antes de criar:

- [ ] Todo item tem `labels` com tipo + prioridade + estado
- [ ] Ordem respeita pais antes de filhos
- [ ] `body_file` existe para cada item
- [ ] Conteúdo em pt-BR

---

## Fase 4 — Dry-run

```bash
python3 scripts/create-github-issues.py --dry-run --manifest .project-manager/manifest.json
```

Revisar output: títulos, labels e ordem. Corrigir manifest se necessário.

---

## Fase 5 — Criar issues

### Opção A — Script (preferida com gh CLI)

```bash
python3 scripts/create-github-issues.py --manifest .project-manager/manifest.json
```

O script:

- Verifica duplicatas via `local-id` no corpo
- Cria issues com labels do manifest
- Substitui referências locais por `#N` conforme cria
- Salva `.project-manager/issue-map.json`

### Opção B — GitHub MCP

Para cada item do manifest (mesma ordem):

1. Ler schema da tool (`create_issue` / `issue_write`)
2. Invocar com:

```json
{
  "owner": "owner",
  "repo": "repo",
  "title": "[Feature] ...",
  "body": "...",
  "labels": ["feature", "high-priority", "ready", "auth"]
}
```

3. Armazenar número retornado no mapa
4. Se tool separada para labels (`add_labels_to_issue`), aplicar labels **idênticas** ao manifest

### Opção C — gh issue create manual (item a item)

```bash
gh issue create --repo owner/repo \
  --title "[Feature] Cadastro com e-mail e senha" \
  --body-file .project-manager/issues/F1.1.md \
  --label "feature" \
  --label "high-priority" \
  --label "ready" \
  --label "auth" \
  --milestone "r1-mvp"
```

**Importante:** passar cada label com `--label` separado (não comma-separated — comportamento varia por versão do gh).

---

## Fase 6 — Segunda passada (dependências)

Após todos os `#N` conhecidos:

1. Atualizar corpos com referências reais:

```markdown
## Épico pai
#101 — Autenticação e gestão de sessão

## Dependências
- **Blocked by:** #101
```

2. Via gh:

```bash
gh issue edit 102 --repo owner/repo --body-file .project-manager/issues/F1.1.md
```

3. Items com dependência aberta → adicionar label `blocked`, remover `ready`:

```bash
gh issue edit 115 --repo owner/repo --add-label "blocked" --remove-label "ready"
```

4. Via MCP: `update_issue` + tools de labels

### Sub-issues (se MCP suportar)

- Feature → sub-issue do Epic
- Task → sub-issue da Feature

---

## Fase 7 — GitHub Project (opcional)

Se `project_number` em `github-config.json`:

```bash
gh project item-add PROJECT_NUMBER --owner @me \
  --url "https://github.com/owner/repo/issues/102"
```

---

## Fase 8 — Relatório

Entregar ao usuário:

```markdown
# Issues criadas — owner/repo

## Conexão
- Repositório: owner/repo
- Método: gh CLI / GitHub MCP
- Labels bootstrap: 15 labels

## Resumo
| Tipo | Qtd | Issues |
|------|-----|--------|
| Epic | 4 | #101, #105, ... |

## Labels aplicadas (amostra)
| Issue | Labels |
|-------|--------|
| #102 | feature, high-priority, ready, auth |

## Mapeamento
| Local | GitHub |
|-------|--------|
| E1 | #101 |
| F1.1 | #102 |

Arquivo: `.project-manager/issue-map.json`
```

---

## Idempotência

Antes de criar, o script busca `local-id` no corpo. Se issue já existe → reutiliza `#N`, não duplica.

Para re-sync:

```bash
gh search issues "local-id=F1.1 repo:owner/repo" --json number,title
```

---

## Tratamento de erros

| Erro | Ação |
|------|------|
| Label não existe | `bash scripts/bootstrap-labels.sh owner/repo` e retry |
| `422 Validation Failed` (label) | Verificar nome exato em `config/labels.json` |
| Rate limit (403/429) | `sleep 60`, retry exponencial |
| Permissão negada | Verificar token scope `repo` + Issues write |
| MCP ausente | Usar gh CLI (não desistir) |

---

## Checklist final

- [ ] `verify-github.sh` passou
- [ ] Labels bootstrap OK
- [ ] Manifest gerado com labels corretas (tipo + prioridade + estado + módulo)
- [ ] Issues criadas na ordem hierárquica
- [ ] `issue-map.json` salvo
- [ ] Dependências `#N` no corpo
- [ ] Items blocked com label `blocked`
- [ ] Relatório entregue ao usuário

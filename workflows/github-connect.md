# Workflow: Conectar ao GitHub do projeto

Usado **antes** de `/project-manager create-github-issues`. O agente **deve executar** os passos abaixo — não apenas descrevê-los.

---

## Objetivo

Estabelecer conexão autenticada com o repositório GitHub alvo, validar permissões e preparar labels padronizadas para criação de issues.

---

## Passo 1 — Identificar repositório

Ordem de resolução (parar no primeiro match válido):

| # | Fonte | Comando |
|---|-------|---------|
| 1 | Argumento do usuário | `owner/repo` explícito |
| 2 | Git remote do workspace | `git remote get-url origin` |
| 3 | GitHub CLI context | `gh repo view --json nameWithOwner -q .nameWithOwner` |
| 4 | Perguntar ao usuário | Se nenhum match |

Normalizar remote para `owner/repo`:

```bash
# SSH: git@github.com:owner/repo.git → owner/repo
# HTTPS: https://github.com/owner/repo.git → owner/repo
git remote get-url origin 2>/dev/null | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##'
```

Registrar em `.project-manager/github-config.json`:

```json
{
  "owner": "owner",
  "repo": "repo",
  "full_name": "owner/repo",
  "default_branch": "main",
  "project_number": null,
  "milestone": null
}
```

---

## Passo 2 — Verificar autenticação

Executar:

```bash
bash scripts/verify-github.sh
```

Ou manualmente:

```bash
gh auth status
gh api user -q .login
gh repo view OWNER/REPO --json name,isPrivate,defaultBranchRef
```

### Se falhar

| Erro | Ação |
|------|------|
| `gh: command not found` | Instalar: https://cli.github.com — ou usar GitHub MCP |
| `not logged in` | Orientar: `gh auth login` (HTTPS + browser ou token) |
| `HTTP 404` | Verificar `owner/repo` e permissões de escrita |
| `Resource not accessible` | Token precisa scope `repo` (classic) ou permissões Issues/R Contents (fine-grained) |

**Scopes mínimos do token:**

- `repo` (repositórios privados) ou `public_repo` (públicos)
- Permissão **Issues: Read and write**
- Permissão **Metadata: Read-only**

---

## Passo 3 — Detectar integração disponível

```
┌─────────────────────────────────────────┐
│ 1. GitHub MCP (CallMcpTool)             │ ← preferido se configurado
│ 2. GitHub CLI (gh)                      │ ← padrão, sempre tentar
│ 3. Export Markdown                      │ ← último recurso
└─────────────────────────────────────────┘
```

### GitHub MCP

1. Listar pastas em `mcps/` do projeto Cursor
2. Procurar servidor com tools: `create_issue`, `issue_write`, `add_issue_comment`, `list_issues`
3. Ler schema JSON de **cada** tool antes de invocar
4. Registrar server name em `github-config.json` → `"mcp_server": "user-GitHub"`

Servidores MCP comuns: `@modelcontextprotocol/server-github`, `github`, `user-GitHub`.

### GitHub CLI

Preferir `gh` para bootstrap de labels e criação em lote via `scripts/create-github-issues.py`.

---

## Passo 4 — Bootstrap de labels

Executar **sempre** antes de criar issues:

```bash
bash scripts/bootstrap-labels.sh OWNER/REPO
```

Isso cria/atualiza labels de `config/labels.json`. Não falha se label já existir.

Verificar:

```bash
gh label list --repo OWNER/REPO --limit 50
```

---

## Passo 5 — Resolver labels por work item

Usar regras determinísticas — **nunca adivinhar labels**:

### Labels obrigatórias (sempre presentes)

| Campo do item | Label |
|---------------|-------|
| `type: epic` | `epic` |
| `type: feature` | `feature` |
| `type: task` | `task` |
| `type: bug` | `bug` |
| `type: technical-debt` | `technical-debt` |

### Label de prioridade (exatamente uma)

| Prioridade no item | Label |
|--------------------|-------|
| P0, P1, high | `high-priority` |
| P2, medium | `medium-priority` |
| P3, low | `low-priority` |

### Label de estado (exatamente uma)

| Condição | Label |
|----------|-------|
| Tem dependência não satisfeita | `blocked` |
| Pronto para dev | `ready` |

### Labels de módulo (zero ou uma)

| Módulo detectado | Label |
|------------------|-------|
| Authentication / Authorization | `auth` |
| Billing / Payments / Stripe | `billing` |
| Notifications | `notifications` |
| Administration | `admin` |
| Infrastructure / CI/CD | `infra` |

### Exemplos finais

| Item | Labels |
|------|--------|
| Epic P0 pronto | `epic`, `high-priority`, `ready` |
| Feature P1 blocked | `feature`, `high-priority`, `blocked`, `auth` |
| Task P2 pronta billing | `task`, `medium-priority`, `ready`, `billing` |
| Bug médio | `bug`, `medium-priority`, `ready` |
| Tech debt alto | `technical-debt`, `high-priority`, `ready`, `billing` |

---

## Passo 6 — Configurar milestone e project (opcional)

### Milestone

```bash
gh api repos/OWNER/REPO/milestones -f title="r1-mvp" -f description="Release MVP" -f due_on="2026-09-01T00:00:00Z"
```

Obter número: `gh api repos/OWNER/REPO/milestones --jq '.[] | select(.title=="r1-mvp") | .number'`

### GitHub Project v2

```bash
gh project list --owner @me
gh project item-add PROJECT_NUMBER --owner @me --url https://github.com/OWNER/REPO/issues/ISSUE_NUMBER
```

Salvar `project_number` em `github-config.json`.

---

## Passo 7 — Confirmar com usuário (dry-run)

Antes de criar issues em massa, apresentar:

```markdown
## Conexão GitHub confirmada

- **Repositório:** owner/repo
- **Autenticação:** @username via gh
- **Labels:** 15 labels padronizadas (bootstrap OK)
- **Issues a criar:** 42 (4 epics, 12 features, 24 tasks, 2 bugs)
- **Milestone:** r1-mvp (opcional)

Prosseguir? (agente continua se usuário pediu create-github-issues explicitamente)
```

---

## Arquivos gerados

| Arquivo | Conteúdo |
|---------|----------|
| `.project-manager/github-config.json` | Repo, milestone, project, mcp_server |
| `.project-manager/manifest.json` | Lista ordenada de issues a criar |
| `.project-manager/issues/*.md` | Corpo de cada issue |
| `.project-manager/issue-map.json` | Mapeamento local-id → #N (pós-criação) |

---

## Checklist de conexão

- [ ] `owner/repo` identificado e salvo
- [ ] `gh auth status` OK ou GitHub MCP autenticado
- [ ] Permissão de escrita em Issues confirmada
- [ ] Labels bootstrap executado
- [ ] Regras de labels documentadas no manifest
- [ ] Pronto para [create-issues.md](create-issues.md)

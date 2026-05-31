---
name: project-manager
description: >-
  Transforma PRDs e requisitos de produto em backlog estruturado no GitHub (Epics,
  Features, Tasks, Bugs, Technical Debt). Conecta ao repositório via gh CLI ou
  GitHub MCP, cria issues com labels padronizadas (epic, feature, task, bug,
  technical-debt, prioridade, ready/blocked). Use quando o usuário mencionar
  project-manager, backlog, PRD, criar issues no GitHub, labels, connect-github,
  sprint planning ou gestão ágil de produto.
---

# Project Manager — AI Project Manager for GitHub Issues

Skill reutilizável para transformar requisitos de produto em backlog estruturado no GitHub.

## Idioma

**Obrigatório:** todo conteúdo de work items (títulos, descrições, critérios de aceite, bugs, tasks, épicos, features, technical debt) deve ser gerado em **português (pt-BR)**.

Documentação de projeto e resumos para stakeholders podem seguir o idioma solicitado pelo usuário; na dúvida, use pt-BR.

## Comandos suportados

| Comando | Workflow |
|---------|----------|
| `/project-manager analyze-prd` | [workflows/analyze-prd.md](workflows/analyze-prd.md) |
| `/project-manager create-backlog` | [workflows/generate-backlog.md](workflows/generate-backlog.md) |
| `/project-manager create-epics` | Gerar apenas épicos a partir do PRD analisado |
| `/project-manager create-features` | Gerar features vinculadas aos épicos |
| `/project-manager create-tasks` | Gerar tasks técnicas vinculadas às features |
| `/project-manager create-bugs` | Gerar bugs identificados (PRD, QA ou contexto) |
| `/project-manager connect-github` | [workflows/github-connect.md](workflows/github-connect.md) |
| `/project-manager create-github-issues` | [workflows/create-issues.md](workflows/create-issues.md) |
| `/project-manager sprint-planning` | [workflows/sprint-planning.md](workflows/sprint-planning.md) |
| `/project-manager release-planning` | [workflows/release-planning.md](workflows/release-planning.md) |

Ao receber um comando parcial (ex.: "crie as tasks do épico X"), aplique o workflow correspondente com escopo reduzido.

## Fluxo principal

```
PRD → Análise → Épicos → Features → Tasks (+ Bugs + Tech Debt)
                              ↓
                    Issues GitHub (create-github-issues)
                              ↓
              implement-issue: /implement-issue #N → PR → merge
```

Após criar issues, oriente o usuário para a sub-skill **[implement-issue](implement-issue/SKILL.md)** (mesmo repositório).

## Sub-skill implement-issue

Local: [`implement-issue/`](implement-issue/SKILL.md)

| Comando | Workflow |
|---------|----------|
| `/implement-issue #N` | [implement-issue/workflows/implement.md](implement-issue/workflows/implement.md) |
| `/implement-issue test #N` | [implement-issue/workflows/test.md](implement-issue/workflows/test.md) |
| `/implement-issue pr #N` | [implement-issue/workflows/finish.md](implement-issue/workflows/finish.md) |

Instalação das duas skills: `bash scripts/install-skills.sh`

---

### Passo 0 — Contexto

Antes de gerar work items:

1. Ler o PRD, feature request ou descrição fornecida pelo usuário.
2. Se existir, ler `examples/sample-prd.md` como referência de formato.
3. Identificar repositório alvo, milestone, projeto GitHub e labels existentes (via MCP ou pergunta ao usuário).
4. Detectar módulos SaaS presentes (ver seção abaixo).

### Passo 1 — Análise (`analyze-prd`)

Seguir [workflows/analyze-prd.md](workflows/analyze-prd.md). Entregar:

- Resumo executivo
- Stakeholders e personas
- Módulos SaaS detectados
- Épicos candidatos (títulos provisórios)
- Riscos, dependências externas e dívida técnica preliminar
- Perguntas em aberto (se houver ambiguidade crítica)

### Passo 2 — Backlog (`create-backlog`)

Seguir [workflows/generate-backlog.md](workflows/generate-backlog.md). Hierarquia:

```
Epic (1..N)
 └── Feature (1..M por Epic)
      └── Task (1..K por Feature, idealmente ≤ 8h cada)
```

Itens transversais (não filhos de feature):

- **Bug** — defeitos conhecidos ou riscos de qualidade
- **Technical Debt** — refatorações e melhorias estruturais

### Passo 3 — Templates

Aplicar rigorosamente os templates em `templates/`:

| Tipo | Template |
|------|----------|
| Epic | [templates/epic.md](templates/epic.md) |
| Feature | [templates/feature.md](templates/feature.md) |
| Task | [templates/task.md](templates/task.md) |
| Bug | [templates/bug.md](templates/bug.md) |
| Technical Debt | [templates/technical-debt.md](templates/technical-debt.md) |

Cada work item deve ser **autossuficiente**: um desenvolvedor deve poder implementar sem reunião adicional.

### Passo 4 — Estimativas

Usar escala de complexidade por item:

| Símbolo | Significado | Horas orientativas |
|---------|-------------|-------------------|
| XS | Trivial | ≤ 2h |
| S | Pequeno | 2–4h |
| M | Médio | 4–8h |
| L | Grande | 8–16h |
| XL | Muito grande | > 16h — **dividir** |

Para features e épicos, usar **story points** (Fibonacci: 1, 2, 3, 5, 8, 13). Itens ≥ 13 pontos ou XL devem ser divididos antes de criar issues.

### Passo 5 — Critérios de aceite

Todo Epic, Feature, Bug e Technical Debt deve ter critérios de aceite **mensuráveis** no formato Given/When/Then ou checklist verificável.

Exemplo:

```markdown
- [ ] Dado um usuário autenticado, quando acessar /settings, então vê preferências de notificação
- [ ] Dado e-mail inválido, quando salvar, então exibe erro inline sem perder dados do formulário
```

### Passo 6 — Dependências

Documentar dependências em cada item. Ao criar issues no GitHub, vincular usando:

- Referências `#123` no corpo da issue
- Seção **Blocked by** / **Blocks** no corpo
- Labels `blocked` quando aguardando dependência
- Relacionamentos nativos do GitHub (sub-issues, linked issues) quando o MCP suportar

## Princípios ágeis (INVEST)

Ao gerar work items:

- **Independent** — minimizar dependências circulares; sinalizar blockers explicitamente
- **Negotiable** — descrever o quê e por quê, não prescrever implementação salvo constraint técnico
- **Valuable** — cada feature entrega valor de usuário mensurável
- **Estimable** — escopo claro o suficiente para estimar
- **Small** — tasks ≤ 8h; features ≤ 1 sprint; épicos ≤ 3 sprints
- **Testable** — critérios de aceite verificáveis por QA ou automação

**Anti-patterns a evitar:**

- Issues genéricas ("Melhorar performance", "Refatorar código")
- Épicos monolíticos que misturam billing + auth + UI
- Tasks sem requisitos de teste
- Critérios de aceite subjetivos ("deve ficar bonito")

## Detecção de módulos SaaS

Ao analisar o PRD, mapear keywords e gerar épicos/tasks apropriados:

| Módulo | Keywords | Épicos/tasks típicos |
|--------|----------|---------------------|
| Authentication | login, SSO, OAuth, MFA, JWT, sessão | Fluxo de login, refresh token, MFA, recuperação de senha |
| Authorization | RBAC, permissões, roles, policies | Modelo de roles, middleware de autorização, UI de permissões |
| User Management | perfil, convite, equipe, membros | CRUD usuário, convites, gestão de equipe |
| Subscription Management | plano, assinatura, trial, upgrade | Planos, trial, upgrade/downgrade, cancelamento |
| Billing | fatura, invoice, cobrança | Geração de faturas, histórico, export PDF |
| Payments | pagamento, checkout, cartão | Checkout, webhooks de pagamento, retry |
| Stripe Integration | Stripe, PaymentIntent, Customer | Setup Stripe, webhooks, sync de assinatura |
| Notifications | e-mail, push, in-app, alertas | Templates, preferências, fila de envio |
| Audit Logs | auditoria, trilha, compliance | Log de ações, retenção, export |
| Administration | admin, backoffice, console | Painel admin, métricas operacionais |
| Settings | configurações, preferências | Settings por usuário/org, defaults |
| Analytics | métricas, dashboard, eventos | Tracking de eventos, dashboards |
| Reports | relatório, export, CSV | Geração de relatórios, agendamento |
| API Layer | REST, GraphQL, webhooks, rate limit | Endpoints, versionamento, documentação OpenAPI |
| Security | CSP, CORS, encryption, secrets | Hardening, rotação de secrets, pentest fixes |
| Monitoring | logs, APM, alertas, Sentry | Instrumentação, alertas, runbooks |
| Infrastructure | deploy, Docker, K8s, cloud | IaC, ambientes, scaling |
| CI/CD | pipeline, GitHub Actions, testes | Workflows CI, deploy automatizado, preview envs |

Quando um módulo for detectado, incluir tasks de **observabilidade**, **testes** e **documentação** específicas desse módulo.

## Labels GitHub

Aplicar labels ao criar issues (criar se não existirem, quando MCP permitir):

| Label | Uso |
|-------|-----|
| `epic` | Épicos |
| `feature` | Features |
| `task` | Tasks técnicas |
| `bug` | Bugs |
| `technical-debt` | Dívida técnica |
| `high-priority` | P0/P1 — sprint atual ou blocker |
| `medium-priority` | P2 — próximo sprint |
| `low-priority` | P3 — backlog |
| `blocked` | Aguardando dependência |
| `ready` | Pronto para desenvolvimento |

Combinar tipo + prioridade (ex.: `feature`, `high-priority`).

## Integração GitHub — conectar e criar issues

**Regra:** ao usar `create-github-issues`, o agente **executa** conexão e criação real — não apenas gera Markdown.

### Fluxo obrigatório

```
connect-github → bootstrap labels → gerar manifest → create-github-issues.py
```

1. **Conectar:** [workflows/github-connect.md](workflows/github-connect.md)
2. **Verificar:** `bash scripts/verify-github.sh owner/repo`
3. **Labels:** `bash scripts/bootstrap-labels.sh owner/repo`
4. **Manifest:** `.project-manager/manifest.json` (ver `config/manifest.example.json`)
5. **Criar:** `python3 scripts/create-github-issues.py --manifest .project-manager/manifest.json`

### Detectar repositório automaticamente

Ordem: argumento do usuário → `git remote get-url origin` → `gh repo view` → perguntar.

Salvar em `.project-manager/github-config.json`.

### Labels — regras determinísticas

Cada issue recebe **3–5 labels** combinadas:

| Camada | Regra |
|--------|-------|
| Tipo | `epic` \| `feature` \| `task` \| `bug` \| `technical-debt` |
| Prioridade | exatamente uma: `high-priority` \| `medium-priority` \| `low-priority` |
| Estado | exatamente uma: `ready` \| `blocked` |
| Módulo | opcional: `auth`, `billing`, `notifications`, `admin`, `infra` |

Mapeamento P0/P1 → `high-priority`, P2 → `medium-priority`, P3 → `low-priority`.  
Dependência não satisfeita → incluir `blocked` e **remover** `ready`.

Catálogo completo: [config/labels.json](config/labels.json)

### GitHub MCP (alternativa)

1. Listar servidores em `mcps/` ou via `CallMcpTool`
2. Procurar tools: `create_issue`, `issue_write`, `add_issue_comment`, `list_issues`
3. **Ler schema de cada tool antes de invocar**
4. Aplicar as **mesmas labels** da tabela acima

Preferir MCP se configurado; caso contrário usar **gh CLI** (nunca parar só por falta de MCP).

### Autenticação gh CLI

Se `gh auth status` falhar, orientar:

```bash
gh auth login -h github.com -p https -s repo,read:org
```

Token precisa permissão **Issues: Read and write**.

### Criação de issues (ordem)

Seguir [workflows/create-issues.md](workflows/create-issues.md):

1. Epics → capturar `#N`
2. Technical Debt
3. Features (referenciam Epic `#N`)
4. Tasks (referenciam Feature `#N`)
5. Bugs
6. Segunda passada: atualizar corpos com dependências `#N` reais
7. Salvar `.project-manager/issue-map.json`

### Formato do corpo da issue

Incluir metadados no topo:

```markdown
<!-- project-manager: type=feature | epic=#12 | points=5 | complexity=M -->
```

## Documentação gerada

Após criar o backlog, produzir (salvar se usuário indicar caminho):

1. **Backlog Summary** — tabela Epic → Features → Tasks com estimativas
2. **Dependency Graph** — lista ou diagrama mermaid de dependências
3. **Risk Register** — riscos com mitigação
4. **Release Outline** — agrupamento sugerido por milestone (ver release-planning)

## Sprint e Release

- Sprint planning: [workflows/sprint-planning.md](workflows/sprint-planning.md)
- Release planning: [workflows/release-planning.md](workflows/release-planning.md)

## Qualidade de saída

Antes de entregar, validar:

- [ ] Todos os work items em pt-BR
- [ ] Templates completos (nenhum campo vazio ou placeholder)
- [ ] Critérios de aceite mensuráveis
- [ ] Nenhuma task XL sem plano de divisão
- [ ] Dependências bidirecionalmente consistentes
- [ ] Módulos SaaS detectados refletidos no backlog
- [ ] Estimativas presentes em todo item
- [ ] Labels sugeridas para cada issue

## Recursos

- [README.md](README.md) — visão geral e instalação
- [workflows/github-connect.md](workflows/github-connect.md) — conexão ao repo
- [config/labels.json](config/labels.json) — catálogo de labels
- [config/manifest.example.json](config/manifest.example.json) — formato do manifest
- [scripts/create-github-issues.py](scripts/create-github-issues.py) — criação em lote
- [examples/sample-prd.md](examples/sample-prd.md) — PRD de exemplo
- [implement-issue/SKILL.md](implement-issue/SKILL.md) — implementação de issues
- [scripts/install-skills.sh](scripts/install-skills.sh) — instalar ambas skills no Cursor

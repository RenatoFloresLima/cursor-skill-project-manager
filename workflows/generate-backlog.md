# Workflow: generate-backlog

Comandos: `/project-manager create-backlog`, `/project-manager create-epics`, `/project-manager create-features`, `/project-manager create-tasks`, `/project-manager create-bugs`

## Objetivo

Transformar a análise de PRD em backlog completo hierárquico, usando templates oficiais, pronto para criação de issues.

## Pré-requisitos

- Análise de PRD concluída (`analyze-prd`) **ou** PRD fornecido inline
- Templates em `templates/` carregados
- Decisão sobre escopo: MVP vs release completo

---

## Hierarquia e limites

```
Epic          → 1 objetivo de negócio, 1–3 sprints
  Feature     → 1 user story coesa, ≤ 1 sprint, ≤ 8 story points
    Task      → 1 unidade de trabalho dev, ≤ 8 horas
Bug           → transversal, vinculado a módulo/feature quando possível
Technical Debt → transversal, vinculado a épico/módulo
```

### Regras de divisão (splitting)

Dividir quando:

| Sinal | Ação |
|-------|------|
| Feature > 8 points | Split por persona, cenário ou camada (API/UI) |
| Task > 8h ou XL | Split por componente ou etapa verificável |
| Epic > 3 sprints | Split por outcome ou fase (MVP vs v2) |
| Critérios de aceite > 8 itens | Provavelmente são 2 features |

---

## Passo 1 — Gerar épicos (`create-epics`)

Para cada épico candidato:

1. Copiar estrutura de `templates/epic.md`
2. Preencher **todos** os campos — sem placeholders
3. Atribuir story points totais e prioridade
4. Listar features filhas na tabela "Features vinculadas"
5. IDs locais: `E1`, `E2`, ... (substituir por `#N` após criação no GitHub)

**Épicos transversais comuns em SaaS** (criar se PRD implica mas não explicita):

| Épico transversal | Quando criar |
|-------------------|--------------|
| Fundação de Autenticação e Segurança | Qualquer app com login |
| Observabilidade e Monitoramento | Produção prevista |
| Pipeline CI/CD e Qualidade | Equipe > 1 dev ou deploy frequente |
| Conformidade e Privacidade (LGPD) | Dados pessoais de usuários BR |

---

## Passo 2 — Gerar features (`create-features`)

Por épico, gerar features seguindo `templates/feature.md`:

Checklist por feature:

- [ ] User story completa (Como/Quero/Para que)
- [ ] ≥ 3 critérios de aceite Given/When/Then
- [ ] Story points (Fibonacci)
- [ ] Complexidade XS–XL
- [ ] Dependências explícitas (issues ou tasks)
- [ ] Tasks sugeridas listadas
- [ ] DoD presente

**Padrões por módulo SaaS:**

### Authentication
- Feature: Cadastro com e-mail e senha
- Feature: Login e sessão persistente
- Feature: Recuperação de senha
- Feature: MFA (TOTP) — se PRD exige

### Subscription + Stripe
- Feature: Seleção de plano e checkout
- Feature: Webhook handler Stripe (subscription.*)
- Feature: Portal do cliente (upgrade/cancelamento)

### Notifications
- Feature: Preferências de notificação
- Feature: E-mail transacional (welcome, reset)
- Feature: Notificações in-app

Cada módulo detectado deve incluir feature de **tratamento de erro** e **empty states**.

---

## Passo 3 — Gerar tasks (`create-tasks`)

Por feature, decompor em tasks técnicas usando `templates/task.md`.

Camadas típicas (gerar tasks conforme aplicável):

| Camada | Exemplos de tasks |
|--------|-------------------|
| Database | Migration, índices, seeds |
| Backend | Service, controller, validação, testes |
| API | Endpoint REST/GraphQL, OpenAPI, rate limit |
| Frontend | Componentes, formulários, estado, testes E2E |
| Integração | Client SDK, webhooks, retry/idempotency |
| Infra | Env vars, secrets, feature flags |
| Docs | README, runbook, changelog |

Por feature, incluir **sempre**:

1. Task de testes (unit + integração mínima)
2. Task de observabilidade (log/metric no fluxo crítico) — se produção

Estimativa por task: XS (≤2h), S (2–4h), M (4–8h). **Nunca entregar L/XL sem subdivisão.**

---

## Passo 4 — Gerar bugs (`create-bugs`)

Fontes:

- Bugs explícitos no PRD ou análise
- Riscos de qualidade identificados ("comportamento inconsistente em X")
- Regressões conhecidas mencionadas pelo usuário

Usar `templates/bug.md`. Se informação insuficiente para reprodução:

- Criar bug com severidade Medium e seção "Investigação necessária"
- Adicionar task de spike vinculada: "Investigar e reproduzir [sintoma]"

---

## Passo 5 — Gerar dívida técnica

Usar `templates/technical-debt.md` para items da análise + inferidos:

- Ausência de testes em módulo core
- Dependências desatualizadas com CVE
- Acoplamento auth/billing em monólito
- Falta de idempotency em webhooks

Priorizar com base em: risco × impacto no roadmap.

---

## Passo 6 — Estabelecer dependências

Construir matriz:

| Item | Blocked by | Blocks |
|------|------------|--------|
| F1.2 | E1, F1.1 | F1.3 |
| T1.3 | T1.1, T1.2 | — |

Validar:

- Sem ciclos (A blocks B blocks A)
- Caminho crítico identificado
- Items blocked tem justificativa e label `blocked` sugerida

---

## Passo 7 — Backlog summary

Gerar tabela consolidada:

```markdown
# Backlog — [Projeto]

| Tipo | ID local | Título | Points/Complexidade | Prioridade | Epic/Parent | Blocked by |
|------|----------|--------|---------------------|------------|-------------|------------|
| Epic | E1 | [...] | 21 pts | P0 | — | — |
| Feature | F1.1 | [...] | 5 pts | P0 | E1 | — |
| Task | T1.1.1 | [...] | S (4h) | P0 | F1.1 | — |
| Bug | B1 | [...] | M | P1 | F2.1 | — |
| Tech Debt | TD1 | [...] | 8 pts | P2 | E1 | — |

**Totais:** X épicos, Y features, Z tasks, W bugs, V tech debt  
**MVP estimado:** N story points ≈ M sprints
```

---

## Passo 8 — Documentação de projeto

Gerar `docs/project/[projeto]-backlog.md` contendo:

1. Backlog summary (tabela acima)
2. Todos os work items completos (templates preenchidos)
3. Grafo de dependências (mermaid)
4. Risk register (copiado/atualizado da análise)
5. Glossário de IDs locais → preparado para mapeamento `#N` GitHub

---

## Comandos parciais

| Comando | Escopo |
|---------|--------|
| `create-epics` | Apenas Passo 1 |
| `create-features` | Passo 2 para épicos indicados ou todos |
| `create-tasks` | Passo 3 para features indicadas ou todas |
| `create-bugs` | Passo 4 apenas |
| `create-backlog` | Passos 1–8 completos |

---

## Checklist final

- [ ] 100% pt-BR
- [ ] Zero placeholders (`[...]` restantes)
- [ ] Todo item tem estimativa
- [ ] Todo Epic/Feature/Bug/TD tem critérios de aceite mensuráveis
- [ ] Tasks ≤ 8h
- [ ] Features ≤ 8 points
- [ ] Labels sugeridas por item
- [ ] Módulos SaaS refletidos
- [ ] Testes e observabilidade incluídos nos fluxos críticos

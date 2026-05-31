# Workflow: sprint-planning

Comando: `/project-manager sprint-planning`

## Objetivo

Selecionar work items do backlog para a sprint, balancear capacidade, resolver dependências e produzir sprint goal + commitment document.

---

## Entradas

- Backlog priorizado (issues GitHub `#N` ou IDs locais)
- **Capacidade da sprint:** story points ou horas (ex.: 40 pts, 2 devs × 10 dias × 6h)
- **Duração:** 1 ou 2 semanas
- **Sprint number** e datas (opcional)
- **Carry-over** da sprint anterior (issues incompletas)

---

## Passo 1 — Calcular capacidade

```
Capacidade efetiva = Capacidade bruta × Fator de foco

Fator de foco típico: 0.7–0.8 (reuniões, bugs, interrupções)
```

Exemplo:

| Dev | Dias | h/dia | Total h | Foco 75% |
|-----|------|-------|---------|------------|
| Dev A | 10 | 6 | 60 | 45h |
| Dev B | 10 | 6 | 60 | 45h |
| **Total** | | | **120h** | **90h ≈ 35–40 pts** |

Converter horas → points se necessário (1 point ≈ 2–3h dev médio).

Reservar **15–20%** para bugs imprevistos e suporte.

---

## Passo 2 — Filtrar candidatos

Incluir apenas issues:

- Label `ready` (sem `blocked`)
- Dependências satisfeitas (blocked-by issues **Closed**)
- Prioridade alinhada ao sprint goal

Excluir:

- Items com `blocked` ativo
- Epics inteiros (planejar **features/tasks**, não épicos)
- XL sem split

---

## Passo 3 — Definir Sprint Goal

Uma frase mensurável. Exemplos:

- "Usuários conseguem criar conta, fazer login e recuperar senha."
- "Checkout Stripe funcional em staging com webhooks idempotentes."

O sprint goal guia trade-offs quando capacidade aperta.

---

## Passo 4 — Selecionar items (algoritmo)

1. Listar features/tasks P0 alinhadas ao sprint goal
2. Incluir dependências obrigatórias ( pré-requisitos no caminho crítico )
3. Somar story points / horas
4. Se > capacidade: remover P2 primeiro, depois fatiar escopo (MVP da feature)
5. Se < capacidade × 80%: puxar 1–2 items P1 preparatórios da próxima sprint
6. Adicionar 1 spike se risco técnico alto não resolvido

Registrar decisões de scope cut explicitamente.

---

## Passo 5 — Balanceamento

Verificar distribuição:

| Dimensão | Check |
|----------|-------|
| Frontend vs Backend | Nenhuma camada > 60% da capacidade |
| Dev por dev | Carga equilibrada ± 20% |
| Sequência | Tasks de mesma feature agrupadas quando possível |
| Riscos | Spike incluído se integração externa nova |
| QA | Tempo para testes E2E nos fluxos entregues |

---

## Passo 6 — Carry-over

Para cada issue incompleta da sprint anterior:

| Issue | Status | Points restantes | Decisão |
|-------|--------|------------------|---------|
| #108 | 70% done | 2 | Carry-over Sprint N+1 |
| #112 | 20% done | 5 | Re-estimar ou split |

Carry-over consome capacidade **antes** de novos items.

---

## Passo 7 — Atualizar GitHub (se MCP/cli disponível)

- Adicionar issues à milestone da sprint
- Mover para coluna "Sprint N" no Project board
- Remover label `ready` de items não selecionados (opcional)
- Comentário em cada issue: "Comprometida Sprint N — [data início–fim]"

---

## Passo 8 — Documento de sprint

Entregar:

```markdown
# Sprint [N] — [Nome/Goal]

**Período:** [DD/MM] – [DD/MM]  
**Sprint Goal:** [Frase]  
**Capacidade:** [X pts / Y horas]  
**Commitment:** [Z pts]

## Métricas alvo

| Métrica | Meta |
|---------|------|
| Velocity (commitment) | Z pts |
| Bugs críticos abertos | 0 ao final |
| Cobertura novos fluxos | ≥ 80% |

## Comprometido

### Features

| Issue | Título | Points | Assignee sugerido | Dependências |
|-------|--------|--------|-------------------|--------------|
| #102 | Cadastro e-mail/senha | 5 | Dev A | #101 ✓ |
| #103 | Login e sessão | 5 | Dev A | #102 |

### Tasks técnicas

| Issue | Título | Complexidade | Parent |
|-------|--------|--------------|--------|
| #110 | Migration users | S | #102 |
| #111 | API POST /auth/register | M | #102 |

### Bugs (se incluídos)

| Issue | Severidade | Estimativa |
|-------|------------|------------|
| #201 | High | M |

### Spike / Investigação

| Issue | Objetivo | Timebox |
|-------|----------|---------|
| #115 | Validar fluxo OAuth Google | 4h |

## Carry-over

| Issue | Points restantes |
|-------|------------------|
| — | — |

## Fora da sprint (explicitamente)

| Issue | Motivo |
|-------|--------|
| #120 | Blocked by #110 |
| #125 | P2 — próxima sprint |

## Riscos da sprint

| Risco | Mitigação |
|-------|-----------|
| Webhook Stripe flaky em staging | Spike #115 + retry policy |

## Definition of Done (sprint)

- [ ] Todas issues comprometidas fechadas ou carry-over documentado
- [ ] CI verde em main
- [ ] Demo do sprint goal realizável
- [ ] Retrospectiva agendada
```

---

## Passo 9 — Cerimônia async (opcional)

Gerar perguntas para o time validar:

1. O sprint goal está claro para todos?
2. Alguma dependência externa não mapeada?
3. Capacidade realista considerando férias/feriados?

---

## Checklist

- [ ] Commitment ≤ capacidade efetiva
- [ ] Sprint goal mensurável
- [ ] Zero items `blocked` no commitment
- [ ] Carry-over contabilizado
- [ ] Caminho crítico coberto
- [ ] Documento em pt-BR
- [ ] GitHub atualizado (se integração disponível)

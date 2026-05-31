# Dívida Técnica: [Título descritivo]

<!-- project-manager: type=technical-debt | priority=[high|medium|low] -->

## Descrição

[Descreva o problema estrutural atual: código legado, acoplamento, ausência de testes, dependência desatualizada, etc. Seja específico sobre o que existe hoje e por que é problemático.]

## Contexto

- **Origem:** [Ex.: MVP rápido, migração incompleta, dependência deprecated]
- **Área afetada:** [Módulo/serviço/camada]
- **Arquivos principais:** `[paths]`
- **Idade da dívida:** [Desde release X / N meses]

## Risco

| Dimensão | Avaliação |
|----------|-----------|
| **Probabilidade de incidente** | [Baixa \| Média \| Alta] |
| **Severidade se ocorrer** | [Baixa \| Média \| Alta] |
| **Risco composto** | [Baixo \| Médio \| Alto \| Crítico] |

**Cenários de falha se não tratado:**

1. [Ex.: deploys cada vez mais lentos e arriscados]
2. [Ex.: impossibilidade de adicionar MFA sem reescrever auth]
3. [Ex.: CVE em dependência sem patch na versão atual]

## Impacto

### Impacto técnico

- [Ex.: 40% do time gasta tempo em bugs relacionados]
- [Ex.: Cobertura de testes < 20% no módulo]
- [Ex.: Tempo de build > 15 min]

### Impacto no produto/negócio

- [Ex.: atrasa feature Y em 2 sprints]
- [Ex.: aumenta custo de infra em X%]

### Impacto no time

- [Ex.: onboarding de devs leva 2 semanas extras no módulo]

## Refatoração proposta

### Objetivo

[Estado desejado após a refatoração — mensurável.]

### Plano de execução

1. **Fase 1 — [Nome]:** [Escopo, entregável, duração estimada]
2. **Fase 2 — [Nome]:** [Escopo, entregável, duração estimada]
3. **Fase 3 — [Nome]:** [Escopo, entregável, duração estimada]

### Estratégia de migração

- [ ] Strangler fig / feature flag / big bang — [justificar]
- [ ] Backward compatibility: [Sim/Não — detalhes]
- [ ] Rollback plan: [Como reverter se falhar]

### Alternativas consideradas

| Alternativa | Prós | Contras | Decisão |
|-------------|------|---------|---------|
| [Manter como está] | [Zero esforço agora] | [Risco crescente] | Rejeitada |
| [Refatoração incremental] | [Baixo risco] | [Mais tempo] | **Escolhida** |

## Prioridade

**[Alta | Média | Baixa]**

**Justificativa:** [Por que agora ou por que pode esperar — link com roadmap.]

## Dependências

- **Blocked by:** [#N ou Nenhuma]
- **Blocks:** [Features #N que dependem desta base]
- **Relacionado a:** [Epic de infra ou security]

## Critérios de aceite

- [ ] [Métrica técnica melhorada — ex.: cobertura ≥ 80%]
- [ ] [Métrica de performance — ex.: build < 5 min]
- [ ] Nenhuma regressão nos fluxos: [listar]
- [ ] Documentação arquitetural atualizada
- [ ] Dependências deprecated removidas ou atualizadas

## Estimativa

| Campo | Valor |
|-------|-------|
| **Complexidade** | [S \| M \| L \| XL] |
| **Story Points** | [3–13] |
| **Sprints** | [1–N] |

## Labels sugeridas

`technical-debt`, `[priority]`, `[módulo]`

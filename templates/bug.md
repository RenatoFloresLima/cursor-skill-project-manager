# Bug: [Título descritivo do defeito]

<!-- project-manager: type=bug | severity=[critical|high|medium|low] | priority=[high|medium|low] -->

## Severidade

**[Critical | High | Medium | Low]**

| Nível | Critério |
|-------|----------|
| Critical | Produção indisponível, perda de dados, breach de segurança |
| High | Funcionalidade core quebrada sem workaround |
| Medium | Funcionalidade degradada com workaround |
| Low | Cosmético ou edge case raro |

## Ambiente

- **Ambiente:** [Produção | Staging | Desenvolvimento]
- **Versão/Build:** [v1.2.3 / commit abc123]
- **Browser/Cliente:** [Chrome 120, iOS 17, etc.]
- **Usuário afetado:** [Todos | Admin | Plano Pro | etc.]

## Passos para reproduzir

1. [Passo 1 — estado inicial claro]
2. [Passo 2 — ação do usuário]
3. [Passo 3 — observação do bug]
4. [Passo N]

**Dados de teste:** [conta/email/IDs fictícios usados na reprodução]

## Comportamento esperado

[Descreva o que deveria acontecer conforme spec, design ou comportamento anterior correto.]

## Comportamento atual

[Descreva o que acontece de fato: mensagem de erro, tela em branco, dado incorreto, etc.]

**Evidências:** [Screenshot, log, stack trace, request/response — colar ou anexar referência]

```
[Stack trace ou log relevante]
```

## Investigação técnica

### Hipóteses

1. [Hipótese 1 — ex.: race condition no webhook]
2. [Hipótese 2 — ex.: validação client-side apenas]

### Áreas do código suspeitas

- `[arquivo/módulo]` — [motivo]
- `[arquivo/módulo]` — [motivo]

### Workaround temporário

[Se existir workaround para usuários, descrever. Se não existir: "Nenhum."]

## Impacto

- **Usuários afetados:** [Estimativa ou "Todos os usuários do módulo X"]
- **Frequência:** [Sempre | Intermitente | Raro]
- **Impacto de negócio:** [Ex.: bloqueia checkout, impede login]

## Dependências

- **Relacionado a:** [#N Feature ou Task]
- **Blocked by:** [Investigação de infra, etc.]
- **Introduzido em:** [PR #N ou release vX.Y — se conhecido]

## Critérios de aceite

- [ ] Bug não reproduzível seguindo passos acima em [ambiente]
- [ ] Teste de regressão adicionado cobrindo o cenário
- [ ] Comportamento validado nos browsers/ambientes afetados
- [ ] [Critério específico do fix, ex.: "Webhook processa evento duplicate idempotently"]

## Estimativa

| Campo | Valor |
|-------|-------|
| **Complexidade** | [XS \| S \| M \| L] |
| **Horas** | [Estimativa de fix + testes] |

## Labels sugeridas

`bug`, `[severity-as-label]`, `[módulo-afetado]`

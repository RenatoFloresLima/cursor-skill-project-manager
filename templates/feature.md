# Feature: [Título da Feature]

<!-- project-manager: type=feature | epic=#[N] | points=[1-8] | complexity=[XS|S|M|L|XL] | priority=[high|medium|low] -->

## Épico pai

**[Título do Épico]** — Epic #N

## Descrição

[O que esta feature entrega, escopo incluído e explicitamente excluído. Deve ser implementável em um sprint.]

## User Story

Como **[persona/role]**,
eu quero **[ação/capacidade]**,
para que **[benefício/valor]**.


### Cenários (opcional)

1. **Cenário principal:** [Fluxo feliz em 2–3 frases]
2. **Cenário alternativo:** [Variação relevante]
3. **Cenário de erro:** [Comportamento esperado em falha]

## Critérios de Aceite

- [ ] **Dado** [contexto], **quando** [ação], **então** [resultado observável]
- [ ] **Dado** [contexto], **quando** [ação], **então** [resultado observável]
- [ ] **Dado** [contexto], **quando** [ação], **então** [resultado observável]
- [ ] Testes automatizados cobrem fluxo principal e casos de erro críticos
- [ ] UI responsiva e acessível (WCAG 2.1 AA) nos fluxos tocados
- [ ] Sem regressões nos fluxos adjacentes: [listar]

## Dependências

- **Blocked by:** [#N — descrição] ou Nenhuma
- **Blocks:** [#N — descrição] ou Nenhuma
- **APIs/Serviços:** [Ex.: Stripe Billing API v2024-11-20]
- **Dados:** [Ex.: Migration X aplicada]

## Complexidade estimada

| Dimensão | Avaliação |
|----------|-----------|
| **Story Points** | [1, 2, 3, 5 ou 8] |
| **Complexidade** | [XS \| S \| M \| L \| XL] |
| **Horas dev (orientativo)** | [4–40h] |
| **Risco técnico** | [Baixo \| Médio \| Alto] |

> Se XL ou > 8 pontos: dividir em features menores antes de implementar.

## Tasks sugeridas

| Task | Complexidade | Dependência |
|------|--------------|-------------|
| [Task 1] | [S] | — |
| [Task 2] | [M] | Task 1 |
| [Task 3] | [S] | — |

## Definição de Pronto (DoD)

- [ ] Código revisado e mergeado
- [ ] Testes passando no CI
- [ ] Critérios de aceite validados
- [ ] Documentação técnica atualizada (se API/contrato mudou)

## Notas de design/técnico

[Links Figma, decisões de UX, constraints de performance ou segurança.]

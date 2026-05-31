# Task: [Título da Task Técnica]

<!-- project-manager: type=task | feature=#[N] | epic=#[N] | complexity=[XS|S|M|L|XL] | priority=[high|medium|low] -->

## Descrição

[Resumo em 1–2 frases do que deve ser implementado. Foco em entrega técnica concreta.]

## Feature pai

**[Título da Feature]** — Feature #N  
**Épico:** [Título do Épico] — Epic #N

## Detalhes técnicos

### Escopo

- [Item 1 a implementar]
- [Item 2 a implementar]
- [Explicitamente fora do escopo: ...]

### Arquivos/módulos prováveis

- `[caminho/arquivo.ext]` — [motivo]
- `[caminho/arquivo.ext]` — [motivo]

### Abordagem sugerida

1. [Passo 1]
2. [Passo 2]
3. [Passo 3]

### Contratos e interfaces

```typescript
// Exemplo de interface ou assinatura esperada (adaptar à stack do projeto)
interface ExemploService {
  executar(input: InputDTO): Promise<ResultadoDTO>;
}
```

### Considerações

- **Performance:** [Ex.: p95 < 200ms]
- **Segurança:** [Ex.: validar input server-side, não expor PII em logs]
- **Compatibilidade:** [Ex.: backward compatible com API v1]

## Notas de implementação

- [Decisão técnica ou padrão do projeto a seguir]
- [Biblioteca/framework preferido no codebase]
- [Feature flags, migrations ou env vars necessárias]

## Requisitos de teste

### Testes unitários

- [ ] [Caso 1: comportamento esperado]
- [ ] [Caso 2: edge case]
- [ ] [Caso 3: erro tratado]

### Testes de integração

- [ ] [Integração com serviço X]
- [ ] [Fluxo end-to-end mínimo]

### Testes manuais (se aplicável)

1. [Passo a passo de verificação manual]

## Dependências

- **Blocked by:** [#N] ou Nenhuma
- **Blocks:** [#N] ou Nenhuma
- **Pré-requisitos:** [Migration, config, outra task]

## Estimativa

| Campo | Valor |
|-------|-------|
| **Complexidade** | [XS \| S \| M \| L \| XL] |
| **Horas** | [2–8h ideal; se > 8h, dividir] |

## Critérios de aceite

- [ ] Implementação conforme detalhes técnicos
- [ ] Testes listados passando localmente e no CI
- [ ] Sem warnings novos de linter/typecheck
- [ ] Code review aprovado

## Referências

- [Link PRD, RFC, doc interna, issue relacionada]

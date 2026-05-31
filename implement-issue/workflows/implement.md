# Workflow: implement

Comando: `/implement-issue #N` ou `/implement-issue code #N`

## Objetivo

Implementar o escopo da issue #N seguindo spec, convenções do projeto e requisitos de teste.

---

## Pré-requisitos

- Issue existe e está acessível (`gh issue view N`)
- Blockers satisfeitos (`check-blockers.sh N` exit 0)
- Branch criada (Fase 2 do SKILL.md)
- Plano validado ou issue suficientemente clara (task com detalhes técnicos)

---

## Passo 1 — Mapear escopo

Extrair da issue:

1. **Critérios de aceite** — checklist Given/When/Then
2. **Detalhes técnicos** — arquivos, interfaces, abordagem
3. **Requisitos de teste** — unitários, integração, manual
4. **Fora do escopo** — respeitar explicitamente

Se a issue for `feature` sem tasks filhas:

- Implementar MVP que cubra critérios de aceite
- Sugerir decomposição em tasks para PRs futuros se > 8h

---

## Passo 2 — Explorar codebase

Antes de editar:

1. Ler arquivos listados na issue (ou equivalentes encontrados)
2. Identificar padrões: naming, imports, estrutura de pastas, testes existentes
3. Localizar testes adjacentes para usar como modelo

**Regra:** novas alterações devem parecer escritas pelo mesmo autor do módulo.

---

## Passo 3 — Implementar

Ordem sugerida:

1. Testes (TDD) **se** a issue pedir ou o projeto exigir
2. Migration/schema **se** pré-requisito documentado
3. Lógica core
4. UI/API exposure
5. Tipos, validações, error handling

Restrições:

- Diff mínimo — sem reformatar arquivos inteiros
- Sem dependências novas salvo necessidade na issue ou padrão do repo
- Feature flags se a issue mencionar rollout gradual

---

## Passo 4 — Auto-revisão

Antes de testar formalmente, verificar:

| Check | Pergunta |
|-------|----------|
| Escopo | Removi código fora da issue? |
| Edge cases | Erros da issue tratados? |
| Segurança | Input validado server-side? Secrets fora do código? |
| i18n | Strings em pt-BR se app for pt-BR? |
| Regressão | Fluxos adjacentes intactos? |

---

## Passo 5 — Handoff para testes

Ao terminar implementação:

1. Listar arquivos alterados
2. Indicar critérios de aceite endereçados
3. Seguir [test.md](test.md)

---

## Por tipo de issue

### Task

Implementação direta. Um PR por task.

### Feature

Preferir implementar tasks filhas. Se uma só entrega:

- Cobrir todos critérios de aceite da feature
- Comentar na issue pai progresso: "Tasks X/Y concluídas"

### Bug

1. Reproduzir (teste que falha ou passos manuais documentados)
2. Corrigir causa raiz (não sintoma)
3. Teste de regressão obrigatório

### Technical Debt

1. Comportamento externo **inalterado** salvo issue dizer o contróario
2. Testes existentes devem continuar passando
3. PR explica **por quê** da refatoração

---

## Checklist

- [ ] Escopo da issue implementado
- [ ] Convenções do projeto seguidas
- [ ] Nenhum refactor não solicitado
- [ ] Pronto para fase de testes

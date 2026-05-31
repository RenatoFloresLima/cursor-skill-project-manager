# Workflow: test

Comando: `/implement-issue test #N` ou `/implement-issue validate #N`

## Objetivo

Validar implementação contra requisitos de teste da issue e pipeline do projeto.

---

## Passo 1 — Detectar comandos do projeto

```bash
bash scripts/detect-test-commands.sh
```

Ordem de detecção (primeiro encontrado vence por categoria):

| Arquivo | Comando inferido |
|---------|------------------|
| `package.json` scripts | `test`, `lint`, `typecheck`, `build` |
| `Makefile` | `make test`, `make lint` |
| `pyproject.toml` / `pytest.ini` | `pytest` |
| `go.mod` | `go test ./...` |
| `Cargo.toml` | `cargo test` |
| `composer.json` | `composer test` ou `vendor/bin/phpunit` |

Se nada detectado, perguntar ao usuário ou ler README/CONTRIBUTING.

**Executar** os comandos — não assumir que passam.

---

## Passo 2 — Testes específicos da issue

Da seção **Requisitos de teste** da issue:

1. Rodar testes unitários listados (criar se issue pediu e não existiam)
2. Rodar testes de integração listados
3. Executar passos de **teste manual** e documentar resultado

Para bugs: confirmar que teste de reprodução agora **passa**.

---

## Passo 3 — Validar critérios de aceite

Para cada critério Given/When/Then:

```markdown
| # | Critério | Status | Evidência |
|---|----------|--------|-----------|
| 1 | Dado X, quando Y, então Z | ✅ | test_auth.py::test_register |
| 2 | ... | ✅ | verificado manualmente — screenshot/descrição |
| 3 | ... | ⏳ | fora do escopo desta task — issue #150 |
```

Status: ✅ atendido | ❌ falhou | ⏳ pendente/fora de escopo

Se ❌: corrigir antes de abrir PR. Se ⏳: documentar e alinhar com usuário.

---

## Passo 4 — Regressão

Rodar suite mínima:

1. Testes dos módulos tocados
2. `lint` + `typecheck` se existirem
3. `build` se CI fizer build

Se falhar por motivo **não relacionado** à issue:

- Verificar se main também falha
- Reportar ao usuário — não mascarar com skip de testes

---

## Passo 5 — Relatório

Entregar resumo:

```markdown
## Resultado dos testes — Issue #N

**Comandos executados:**
- `npm test` — ✅
- `npm run lint` — ✅

**Critérios de aceite:** 4/4 ✅

**Observações:** [testes manuais, limitações, follow-ups]
```

Se tudo OK → seguir [finish.md](finish.md).

---

## Checklist

- [ ] Comandos do projeto executados e passando
- [ ] Requisitos de teste da issue cobertos
- [ ] Critérios de aceite mapeados com evidência
- [ ] Nenhum teste desabilitado sem justificativa na issue

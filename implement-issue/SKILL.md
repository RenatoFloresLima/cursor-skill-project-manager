---
name: implement-issue
description: >-
  Implementa issues do GitHub de ponta a ponta: lê spec e critérios de aceite,
  verifica blockers, cria branch, codifica, testa, abre PR e valida DoD.
  Integra com issues criadas pelo project-manager (.project-manager/issue-map.json).
  Use quando o usuário pedir implementar issue, task, feature, bug, executar
  backlog, fechar issue, ou mencionar implement-issue e número de issue (#N).
---

# Implement Issue — Execução de work items GitHub

Skill para **implementar** issues já criadas no GitHub (tipicamente via [project-manager](../SKILL.md)).

Faz parte do repositório **project-manager** (`implement-issue/`). Instale com `bash scripts/install-skills.sh`.

## Idioma

Comunicação com o usuário e conteúdo de PR/comentários em issues: **português (pt-BR)**, salvo se o projeto exigir outro idioma.

## Comandos suportados

| Comando | Workflow |
|---------|----------|
| `/implement-issue #N` | [workflows/implement.md](workflows/implement.md) — fluxo completo |
| `/implement-issue start #N` | Fases 0–2: contexto, branch, plano |
| `/implement-issue code #N` | Fase 3: implementação |
| `/implement-issue test #N` | [workflows/test.md](workflows/test.md) |
| `/implement-issue pr #N` | [workflows/finish.md](workflows/finish.md) — PR + comentário na issue |
| `/implement-issue validate #N` | Validar critérios de aceite sem codar |

Comando parcial (ex.: "implemente a task #145") → aplicar workflow completo com escopo da issue.

## Fluxo principal

```
Issue #N → Contexto → Blockers OK? → Branch → Implementar → Testar → PR → DoD
                ↑
    gh issue view / .project-manager/ / issue pai
```

## Regras gerais

1. **Executar comandos** — não apenas descrever. Rodar `gh`, testes, linter.
2. **Escopo mínimo** — implementar só o que a issue pede; não refatorar código adjacente.
3. **Task antes de Feature** — se pedirem feature inteira, implementar tasks filhas em ordem de dependência ou avisar que o ideal é uma task por PR.
4. **Epic nunca** — épicos são containers; redirecionar para feature/task filha.
5. **Blockers** — se `blocked` ou dependência aberta, parar e reportar (ver Fase 0).
6. **Commits** — só quando o usuário pedir; PR pode ser aberto sem commit local se política do projeto exigir.
7. **Integração project-manager** — metadados `<!-- project-manager: type=... -->` no corpo indicam tipo e hierarquia.

## Fase 0 — Carregar contexto (obrigatória)

Ordem de leitura:

1. `bash scripts/fetch-issue.sh N` (ou `gh issue view N --json ...`)
2. Se existir `.project-manager/issue-map.json`, resolver `local_id` ↔ `#N`
3. Se existir `.project-manager/issues/*.md` correspondente, ler spec local
4. Issue **pai** (feature/epic referenciados no corpo)
5. Issues **filhas** abertas (se implementando feature — listar tasks pendentes)
6. Explorar codebase nos caminhos sugeridos na issue

Detectar repositório: `git remote get-url origin` → `gh repo view`.

### Tipos de issue

| Label / type | Ação |
|--------------|------|
| `task` | Implementar diretamente — unidade ideal de trabalho |
| `feature` | Ler critérios de aceite; implementar tasks filhas ou MVP se não houver tasks |
| `bug` | Reproduzir → corrigir → teste de regressão |
| `technical-debt` | Refatoração delimitada; manter comportamento |
| `epic` | **Não implementar** — listar features/tasks filhas e perguntar qual executar |

### Verificar blockers

```bash
bash scripts/check-blockers.sh N
```

Se falhar: listar issues bloqueadoras abertas e **não** iniciar implementação.

## Fase 1 — Plano (antes de codar)

Entregar plano curto:

- Escopo incluído / excluído
- Arquivos a tocar (confirmados no codebase)
- Abordagem em 3–5 passos
- Comandos de teste que serão usados

Aguardar confirmação do usuário **somente** se escopo ambíguo ou issue XL. Caso contrário, prosseguir.

## Fase 2 — Branch

Naming convention:

```
task/123-slug-curto
feature/123-slug-curto
fix/123-slug-curto
tech-debt/123-slug-curto
```

```bash
git fetch origin
git checkout -b task/123-slug origin/main   # ou default branch detectada
```

Atualizar issue (opcional, se WRITE):

```bash
gh issue edit N --add-assignee @me
gh issue comment N --body "Iniciando implementação — branch \`task/123-slug\`"
```

## Fases 3–5

- Implementação: [workflows/implement.md](workflows/implement.md)
- Testes: [workflows/test.md](workflows/test.md)
- PR e conclusão: [workflows/finish.md](workflows/finish.md)

## Definition of Done

Antes de marcar como concluído:

- [ ] Critérios de aceite da issue verificados (checklist no PR)
- [ ] Testes da issue + suite do projeto passando
- [ ] Linter/typecheck sem erros novos
- [ ] PR aberto com `Closes #N` (ou `Fixes #N` para bugs)
- [ ] Escopo limitado à issue — sem drive-by refactors

## Integração com outras skills

| Situação | Skill |
|----------|-------|
| PR aberto, CI falhando ou comentários | `babysit` |
| Dividir issue grande em PRs menores | `split-to-prs` |
| Criar backlog / issues | `project-manager` |

## Scripts

| Script | Uso |
|--------|-----|
| [scripts/fetch-issue.sh](scripts/fetch-issue.sh) | Busca issue + metadados + pais |
| [scripts/check-blockers.sh](scripts/check-blockers.sh) | Valida dependências fechadas |
| [scripts/detect-test-commands.sh](scripts/detect-test-commands.sh) | Infere comandos de teste do projeto |

## Recursos

- [README.md](README.md) — instalação
- [workflows/implement.md](workflows/implement.md) — implementação detalhada
- [workflows/test.md](workflows/test.md) — testes e aceite
- [workflows/finish.md](workflows/finish.md) — PR e encerramento
- [templates/pr-body.md](templates/pr-body.md) — corpo do PR
- [examples/prompts.md](examples/prompts.md) — prompts de exemplo

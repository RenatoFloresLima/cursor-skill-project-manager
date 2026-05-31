# Workflow: finish

Comando: `/implement-issue pr #N`

## Objetivo

Abrir PR, vincular issue, documentar validação e preparar encerramento.

---

## Passo 1 — Preparar commits

Somente se o usuário pediu commit ou política do projeto exigir:

```bash
git status
git add <arquivos relevantes>
git commit -m "$(cat <<'EOF'
feat(escopo): descrição concisa

Implementa #N — [título curto da issue]
EOF
)"
```

Mensagem: foco no **porquê**, referência `#N` no corpo.

---

## Passo 2 — Push

```bash
git push -u origin HEAD
```

Se push falhar por permissão, reportar — não force push.

---

## Passo 3 — Criar PR

Usar template [templates/pr-body.md](../templates/pr-body.md).

```bash
gh pr create \
  --title "[Task] Título da issue (#N)" \
  --body-file /tmp/pr-body.md \
  --base main
```

Ajustar `--base` para branch default do repo.

**Obrigatório no corpo:**

- `Closes #N` (ou `Fixes #N` para bugs)
- Checklist de critérios de aceite
- Comandos de teste executados
- Notas de deploy/migration se aplicável

---

## Passo 4 — Atualizar issue

```bash
gh issue comment N --body "$(cat <<'EOF'
## Implementação em PR

PR: #<PR_NUMBER>

### Critérios de aceite
- [x] Critério 1 — evidência
- [x] Critério 2 — evidência

### Testes
- `npm test` ✅
- `npm run lint` ✅

Aguardando review/merge.
EOF
)"
```

Opcional: remover label `ready`, adicionar label `in-progress` se existir no repo.

---

## Passo 5 — Pós-merge (quando aplicável)

Após merge confirmado pelo usuário ou CI:

1. Verificar issue #N fechada automaticamente (`Closes #N`)
2. Se issue **pai** (feature): comentar progresso
3. Desbloquear issues com `Blocked by #N` — remover label `blocked` se todas deps fechadas

Para PR com CI falhando ou review pendente → usar skill **babysit**.

---

## Encerramento feature (opcional)

Quando **todas** tasks filhas de feature #F estiverem fechadas:

```bash
gh issue view F --json body -q .body   # revisar critérios de aceite da feature
```

Comentar na feature:

```markdown
Todas as tasks concluídas. Critérios de aceite da feature validados via PRs #X, #Y, #Z.
```

Fechar feature manualmente se critérios cumpridos e issue ainda aberta.

---

## Checklist

- [ ] PR criado com `Closes #N`
- [ ] Critérios de aceite no corpo do PR
- [ ] Issue comentada com link do PR
- [ ] CI disparado (verificar `gh pr checks`)
- [ ] Usuário informado sobre próximo passo (review, babysit, merge)

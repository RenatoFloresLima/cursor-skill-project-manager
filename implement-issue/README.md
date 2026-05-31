# implement-issue — Cursor Skill

Sub-skill do pacote **[project-manager](../README.md)** para **implementar issues do GitHub** de ponta a ponta: contexto → branch → código → testes → PR → DoD.

Integra com issues criadas pelo project-manager via `.project-manager/issue-map.json` e metadados no corpo das issues.

> Esta skill **não tem repositório próprio**. Ela vive em `project-manager/implement-issue/` e é registrada no Cursor via `scripts/install-skills.sh`.

---

## O que esta skill faz

| Fase | Ação |
|------|------|
| Contexto | Lê issue via `gh`, spec local, issue pai |
| Blockers | Valida dependências fechadas |
| Branch | `task/123-slug` a partir da default branch |
| Implementação | Escopo mínimo, convenções do projeto |
| Testes | Detecta e executa suite + critérios de aceite |
| PR | Template com `Closes #N` e checklist |
| Conclusão | Comentário na issue, handoff para `babysit` |

---

## Instalação

A `implement-issue` é instalada **junto** com o project-manager:

```bash
git clone https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  ~/.cursor/skills/project-manager

bash ~/.cursor/skills/project-manager/scripts/install-skills.sh
```

O script cria o symlink `~/.cursor/skills/implement-issue` → `project-manager/implement-issue/`.

**No repositório do projeto (equipe):**

```bash
git submodule add https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  .cursor/skills/project-manager

bash .cursor/skills/project-manager/scripts/install-skills.sh .cursor/skills
```

Skills ficam em **`~/.cursor/skills/`** ou **`.cursor/skills/`** — nunca em `~/.cursor/skills-cursor/`.

---

## Como invocar no Cursor

1. Abra a **raiz do seu projeto Git** no Cursor (onde está `.git/`), não a pasta da skill.
2. Use o **Agent chat** (modo Agent).
3. Invoque por comando, nome ou linguagem natural:

| Forma | Exemplo |
|-------|---------|
| Comando | `/implement-issue #123` |
| Comando parcial | `/implement-issue test #123` |
| Nome explícito | "Use a skill implement-issue na issue #123" |
| Linguagem natural | "Implemente a task #123, teste e abra PR" |

---

## Como usar em um projeto Git

### 1. Abra o projeto no Cursor

Abra a pasta raiz do repositório Git. A skill opera sobre **seu código**, não sobre `project-manager/implement-issue/`.

### 2. Verifique GitHub e blockers

```bash
gh auth status
SKILL=".cursor/skills/implement-issue"
bash "$SKILL/scripts/fetch-issue.sh" 123
bash "$SKILL/scripts/check-blockers.sh" 123
```

Alternativa sem symlink (submodule apenas):

```bash
bash .cursor/skills/project-manager/implement-issue/scripts/check-blockers.sh 123
```

### 3. Escolha a issue certa

| Tipo | Recomendação |
|------|--------------|
| **Task** | Ideal — uma task = um PR |
| **Bug** | Reproduzir, corrigir, teste de regressão |
| **Feature** | Prefira tasks filhas |
| **Epic** | Não implemente — liste filhas |

Número real após `create-github-issues`:

```bash
cat .project-manager/issue-map.json
# "T1.1.1": 110  →  /implement-issue #110
```

### 4. Invoque a skill

```
/implement-issue #110
```

Comandos parciais: `start`, `code`, `test`, `pr`, `validate` — ver [SKILL.md](SKILL.md).

### 5. Revise e conclua

```
Use babysit neste PR até ficar pronto para merge.
```

Próxima task: `/implement-issue #111`

---

## Comandos

| Comando | Descrição |
|---------|-----------|
| `/implement-issue #N` | Fluxo completo |
| `/implement-issue start #N` | Contexto + branch + plano |
| `/implement-issue code #N` | Só implementação |
| `/implement-issue test #N` | Testes e aceite |
| `/implement-issue pr #N` | Abrir PR |
| `/implement-issue validate #N` | Validar aceite sem codar |

Mais prompts: [examples/prompts.md](examples/prompts.md)

---

## Exemplo completo (com project-manager)

```
/project-manager analyze-prd
/project-manager create-backlog
/project-manager connect-github
/project-manager create-github-issues
/project-manager sprint-planning

/implement-issue #110
/implement-issue #111

Use babysit no PR #45
```

Documentação do backlog: [../README.md](../README.md)

---

## Scripts

```bash
SKILL=".cursor/skills/implement-issue"
bash "$SKILL/scripts/fetch-issue.sh" 123
bash "$SKILL/scripts/check-blockers.sh" 123
bash "$SKILL/scripts/detect-test-commands.sh"
```

---

## Licença

MIT — mesmo repositório project-manager.

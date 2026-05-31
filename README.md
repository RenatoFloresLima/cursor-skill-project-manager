# project-manager — Cursor Skill

Skill do [Cursor](https://cursor.com) que transforma PRDs e requisitos de produto em backlog estruturado no GitHub: **Épicos → Features → Tasks**, além de Bugs e Dívida Técnica — com issues criadas automaticamente e labels padronizadas.

Todo o conteúdo gerado (issues, critérios de aceite, descrições) é produzido em **português (pt-BR)**.

Skill complementar para **implementar** as issues: [implement-issue](../implement-issue/README.md).

---

## O que esta skill faz

| Capacidade | Descrição |
|------------|-----------|
| Análise de PRD | Extrai épicos, riscos, módulos SaaS e dependências |
| Backlog estruturado | Decompõe requisitos em Epic → Feature → Task |
| Critérios de aceite | Formato Given/When/Then mensurável |
| Estimativas | Story points e complexidade XS–XL |
| GitHub Issues | Conecta ao repo do projeto e cria issues com labels |
| Sprint / Release | Planejamento ágil com capacidade e milestones |

---

## Pré-requisitos

- [Cursor](https://cursor.com) instalado
- Projeto Git com repositório no GitHub
- [GitHub CLI (`gh`)](https://cli.github.com) — recomendado para criar issues
- `python3` e `jq` — para scripts de bootstrap e criação em lote

Autentique o GitHub CLI uma vez:

```bash
gh auth login -h github.com -p https -s repo,read:org
```

---

## Instalação

Escolha **uma** das opções. Skills devem ficar em **`~/.cursor/skills/`** ou **`.cursor/skills/`** — nunca em `~/.cursor/skills-cursor/`.

### Opção A — Skill pessoal (todos os seus projetos)

```bash
git clone https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  ~/.cursor/skills/project-manager
```

Atualizar:

```bash
cd ~/.cursor/skills/project-manager && git pull
```

### Opção B — Skill no repositório do projeto (equipe)

```bash
mkdir -p .cursor/skills
git submodule add https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  .cursor/skills/project-manager
git commit -m "Adiciona skill project-manager do Cursor"
git push
```

Colaboradores:

```bash
git submodule update --init --recursive
```

### Opção C — Cópia direta (sem submodule)

```bash
mkdir -p ~/.cursor/skills
cp -r /caminho/para/project-manager ~/.cursor/skills/project-manager
```

Instale também **[implement-issue](../implement-issue/README.md)** para executar as tasks após criar issues.

---

## Como invocar no Cursor

1. Abra a **raiz do seu projeto Git** no Cursor (onde está `.git/`), não a pasta da skill.
2. Use o **Agent chat** (modo Agent).
3. Invoque por comando, nome ou linguagem natural:

| Forma | Exemplo |
|-------|---------|
| Comando | `/project-manager analyze-prd` |
| Nome explícito | "Use a skill project-manager" |
| Linguagem natural | "Analise o PRD em docs/prd.md e crie issues no GitHub" |

---

## Como usar em um projeto Git

### 1. Abra o projeto no Cursor

Abra a pasta raiz do repositório Git (onde existe `.git/` e `origin` apontando para o GitHub).

### 2. Verifique a conexão com o GitHub

No terminal do projeto:

```bash
bash .cursor/skills/project-manager/scripts/verify-github.sh
```

O script detecta `owner/repo` a partir de `git remote get-url origin`.

Se falhar: `gh auth login`

### 3. Analise o PRD

No chat:

```
/project-manager analyze-prd
```

Cole o PRD ou aponte para um arquivo (ex.: `docs/prd.md`).

### 4. Gere o backlog

```
/project-manager create-backlog
```

O agente produz épicos, features, tasks, bugs e dívida técnica em português.

### 5. Conecte ao GitHub e crie as issues

```
/project-manager connect-github
/project-manager create-github-issues
```

Fluxo executado pelo agente:

1. Valida autenticação (`verify-github.sh`)
2. Cria labels padronizadas (`bootstrap-labels.sh`)
3. Gera `.project-manager/manifest.json` e corpos em `.project-manager/issues/`
4. Publica issues no repositório (`create-github-issues.py`)

Arquivos gerados **no seu projeto**:

```
seu-projeto/
└── .project-manager/
    ├── github-config.json
    ├── manifest.json
    ├── issue-map.json       # T1.1.1 → #110
    └── issues/
        ├── E1.md
        └── T1.1.1.md
```

Confirme issues criadas:

```bash
gh issue list --label task --label ready
cat .project-manager/issue-map.json
```

Opcional — ignore rascunhos locais:

```gitignore
.project-manager/
```

### 6. Sprint e release (opcional)

```
/project-manager sprint-planning
/project-manager release-planning
```

### 7. Implemente as tasks (skill implement-issue)

Esta skill **cria** o backlog; a execução é feita pela skill **implement-issue**.

Instale em `~/.cursor/skills/implement-issue` ou `.cursor/skills/implement-issue`.

Para cada task (use o número real de `issue-map.json` ou `gh issue list`):

```bash
bash .cursor/skills/implement-issue/scripts/check-blockers.sh 110
```

```
/implement-issue #110
```

Após o PR: `Use babysit neste PR até ficar merge-ready.`

Guia completo: [implement-issue/README.md](../implement-issue/README.md)

---

## Comandos disponíveis

| Comando | Ação |
|---------|------|
| `/project-manager analyze-prd` | Analisa PRD e identifica épicos/riscos |
| `/project-manager create-backlog` | Gera backlog completo |
| `/project-manager create-epics` | Apenas épicos |
| `/project-manager create-features` | Apenas features |
| `/project-manager create-tasks` | Apenas tasks |
| `/project-manager create-bugs` | Apenas bugs |
| `/project-manager connect-github` | Valida repo + bootstrap de labels |
| `/project-manager create-github-issues` | Cria issues no GitHub |
| `/project-manager sprint-planning` | Planeja sprint com capacidade |
| `/project-manager release-planning` | Agrupa releases/milestones |

---

## Exemplo completo (project-manager → implement-issue)

```
/project-manager analyze-prd
[cole PRD ou: leia docs/prd.md]

/project-manager create-backlog
/project-manager connect-github
/project-manager create-github-issues

/project-manager sprint-planning

/implement-issue #110
/implement-issue #111

Use babysit no PR #45
```

---

## Labels criadas no GitHub

| Camada | Labels |
|--------|--------|
| **Tipo** | `epic`, `feature`, `task`, `bug`, `technical-debt` |
| **Prioridade** | `high-priority`, `medium-priority`, `low-priority` |
| **Estado** | `ready`, `blocked` |
| **Módulo** | `auth`, `billing`, `notifications`, `admin`, `infra` |

Catálogo: [`config/labels.json`](config/labels.json)

---

## Scripts (uso manual)

Na raiz do **seu projeto**:

```bash
SKILL=".cursor/skills/project-manager"

bash "$SKILL/scripts/verify-github.sh"
bash "$SKILL/scripts/bootstrap-labels.sh owner/repo"

python3 "$SKILL/scripts/create-github-issues.py" \
  --dry-run --manifest .project-manager/manifest.json

python3 "$SKILL/scripts/create-github-issues.py" \
  --manifest .project-manager/manifest.json
```

---

## GitHub MCP (alternativa ao `gh`)

1. **Cursor Settings → MCP → Add server**
2. Configure o servidor GitHub ([documentação MCP](https://cursor.com/docs/context/mcp))
3. O skill detecta o MCP e cria issues com as mesmas labels

---

## Estrutura deste repositório

```
├── SKILL.md
├── README.md
├── config/
├── scripts/
├── templates/
├── workflows/
└── examples/
```

---

## Módulos SaaS detectados automaticamente

Authentication · Authorization · User Management · Subscription · Billing · Payments · Stripe · Notifications · Audit Logs · Admin · Settings · Analytics · Reports · API · Security · Monitoring · Infrastructure · CI/CD

---

## Licença

MIT

# project-manager — Cursor Skills

Repositório de skills do [Cursor](https://cursor.com) para gestão ágil no GitHub: do **PRD ao PR mergeado**.

Inclui duas skills:

| Skill | Pasta | Função |
|-------|-------|--------|
| **project-manager** | `/` (raiz) | PRD → backlog → issues GitHub |
| **implement-issue** | [`implement-issue/`](implement-issue/README.md) | Issue → branch → código → testes → PR |

Todo conteúdo de work items em **português (pt-BR)**.

---

## O que o project-manager faz

| Capacidade | Descrição |
|------------|-----------|
| Análise de PRD | Extrai épicos, riscos, módulos SaaS e dependências |
| Backlog estruturado | Decompõe requisitos em Epic → Feature → Task |
| Critérios de aceite | Formato Given/When/Then mensurável |
| Estimativas | Story points e complexidade XS–XL |
| GitHub Issues | Conecta ao repo e cria issues com labels |
| Sprint / Release | Planejamento ágil com capacidade e milestones |

Para **implementar** as issues: skill [`implement-issue`](implement-issue/README.md) (mesmo repositório).

---

## Pré-requisitos

- [Cursor](https://cursor.com)
- Projeto Git com repositório no GitHub
- [GitHub CLI (`gh`)](https://cli.github.com)
- `python3` e `jq`

```bash
gh auth login -h github.com -p https -s repo,read:org
```

---

## Instalação

Skills ficam em **`~/.cursor/skills/`** ou **`.cursor/skills/`** — nunca em `~/.cursor/skills-cursor/`.

### Opção A — Pessoal (recomendado)

```bash
git clone https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  ~/.cursor/skills/project-manager

bash ~/.cursor/skills/project-manager/scripts/install-skills.sh
```

O script `install-skills.sh` registra **project-manager** e cria symlink **implement-issue** no Cursor.

Atualizar:

```bash
cd ~/.cursor/skills/project-manager && git pull
bash scripts/install-skills.sh
```

### Opção B — No repositório do projeto (equipe)

```bash
mkdir -p .cursor/skills
git submodule add https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  .cursor/skills/project-manager

bash .cursor/skills/project-manager/scripts/install-skills.sh .cursor/skills
git commit -m "Adiciona Cursor skills project-manager"
git push
```

Colaboradores:

```bash
git submodule update --init --recursive
bash .cursor/skills/project-manager/scripts/install-skills.sh .cursor/skills
```

### Opção C — Cópia direta

```bash
cp -r /caminho/para/project-manager ~/.cursor/skills/project-manager
bash ~/.cursor/skills/project-manager/scripts/install-skills.sh
```

---

## Como invocar no Cursor

1. Abra a **raiz do seu projeto Git** no Cursor (onde está `.git/`).
2. Use o **Agent chat** (modo Agent).
3. Invoque por comando ou linguagem natural:

| Skill | Exemplo |
|-------|---------|
| project-manager | `/project-manager analyze-prd` |
| implement-issue | `/implement-issue #110` |

---

## Como usar — Fase 1: Backlog

### 1. Abra o projeto no Cursor

Pasta raiz do repositório Git (`origin` no GitHub).

### 2. Verifique GitHub

```bash
bash .cursor/skills/project-manager/scripts/verify-github.sh
```

### 3. Analise o PRD

```
/project-manager analyze-prd
```

Cole o PRD ou aponte para `docs/prd.md`.

### 4. Gere backlog e issues

```
/project-manager create-backlog
/project-manager connect-github
/project-manager create-github-issues
```

Arquivos gerados no **seu projeto**:

```
seu-projeto/.project-manager/
├── issue-map.json    # T1.1.1 → #110
└── issues/
```

Confirme:

```bash
gh issue list --label task --label ready
cat .project-manager/issue-map.json
```

### 5. Sprint (opcional)

```
/project-manager sprint-planning
```

---

## Como usar — Fase 2: Implementação

Skill **[implement-issue](implement-issue/README.md)** — já incluída neste repo.

```bash
bash .cursor/skills/implement-issue/scripts/check-blockers.sh 110
```

```
/implement-issue #110
```

Após PR: `Use babysit neste PR até ficar merge-ready.`

---

## Exemplo completo

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

---

## Comandos project-manager

| Comando | Ação |
|---------|------|
| `/project-manager analyze-prd` | Analisa PRD |
| `/project-manager create-backlog` | Gera backlog |
| `/project-manager connect-github` | Valida repo + labels |
| `/project-manager create-github-issues` | Cria issues |
| `/project-manager sprint-planning` | Planeja sprint |
| `/project-manager release-planning` | Planeja release |

Comandos **implement-issue**: [implement-issue/README.md](implement-issue/README.md)

---

## Labels GitHub

| Camada | Labels |
|--------|--------|
| Tipo | `epic`, `feature`, `task`, `bug`, `technical-debt` |
| Prioridade | `high-priority`, `medium-priority`, `low-priority` |
| Estado | `ready`, `blocked` |
| Módulo | `auth`, `billing`, `notifications`, `admin`, `infra` |

Catálogo: [`config/labels.json`](config/labels.json)

---

## Estrutura deste repositório

```
project-manager/
├── SKILL.md                    # Skill de backlog
├── README.md                   # Este arquivo
├── scripts/
│   ├── install-skills.sh       # Registra ambas skills no Cursor
│   ├── verify-github.sh
│   ├── bootstrap-labels.sh
│   └── create-github-issues.py
├── implement-issue/            # Sub-skill de implementação
│   ├── SKILL.md
│   ├── README.md
│   ├── workflows/
│   └── scripts/
├── config/
├── templates/
├── workflows/
└── examples/
```

---

## Módulos SaaS detectados

Authentication · Authorization · User Management · Subscription · Billing · Payments · Stripe · Notifications · Audit Logs · Admin · Settings · Analytics · Reports · API · Security · Monitoring · Infrastructure · CI/CD

---

## Licença

MIT

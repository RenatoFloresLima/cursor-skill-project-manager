# project-manager — Cursor Skill

Skill do [Cursor](https://cursor.com) que transforma PRDs e requisitos de produto em backlog estruturado no GitHub: **Épicos → Features → Tasks**, além de Bugs e Dívida Técnica — com issues criadas automaticamente e labels padronizadas.

Todo o conteúdo gerado (issues, critérios de aceite, descrições) é produzido em **português (pt-BR)**.

---

## O que este skill faz

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

Escolha **uma** das opções abaixo.

### Opção A — Skill pessoal (todos os seus projetos)

Disponível em qualquer workspace aberto no Cursor:

```bash
git clone https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  ~/.cursor/skills/project-manager
```

Atualizar depois:

```bash
cd ~/.cursor/skills/project-manager && git pull
```

### Opção B — Skill no repositório do projeto (equipe)

Compartilhe o skill com quem clona o repo — ideal para times:

```bash
# Na raiz do seu projeto Git
mkdir -p .cursor/skills
git submodule add https://github.com/RenatoFloresLima/cursor-skill-project-manager.git \
  .cursor/skills/project-manager
git commit -m "Adiciona skill project-manager do Cursor"
git push
```

Colaboradores inicializam submodules:

```bash
git submodule update --init --recursive
```

### Opção C — Cópia direta (sem submodule)

```bash
mkdir -p .cursor/skills
cp -r /caminho/para/project-manager .cursor/skills/project-manager
```

---

## Como usar em um projeto Git

### 1. Abra o projeto no Cursor

Abra a pasta raiz do repositório Git (onde existe `.git/` e `origin` apontando para o GitHub).

### 2. Verifique a conexão com o GitHub

No terminal do projeto:

```bash
bash .cursor/skills/project-manager/scripts/verify-github.sh
```

O script detecta automaticamente `owner/repo` a partir de `git remote get-url origin`.

Se falhar, autentique: `gh auth login`

### 3. Invoque o skill no chat do Cursor

Mencione o skill ou use os comandos:

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

Arquivos gerados **no seu projeto** (não no skill):

```
seu-projeto/
└── .project-manager/
    ├── github-config.json   # repo detectado
    ├── manifest.json        # lista de issues + labels
    ├── issue-map.json       # mapeamento E1 → #101
    └── issues/
        ├── E1.md
        ├── F1.1.md
        └── ...
```

Adicione ao `.gitignore` do projeto se não quiser versionar rascunhos:

```gitignore
.project-manager/
```

### 6. Sprint e release (opcional)

```
/project-manager sprint-planning
/project-manager release-planning
```

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

Também funciona em linguagem natural:

> "Analise o PRD em `docs/prd.md` e crie todas as issues no GitHub deste repo"

---

## Labels criadas no GitHub

O skill aplica labels automaticamente em cada issue:

| Camada | Labels |
|--------|--------|
| **Tipo** | `epic`, `feature`, `task`, `bug`, `technical-debt` |
| **Prioridade** | `high-priority`, `medium-priority`, `low-priority` |
| **Estado** | `ready`, `blocked` |
| **Módulo** | `auth`, `billing`, `notifications`, `admin`, `infra` |

Catálogo completo: [`config/labels.json`](config/labels.json)

---

## Scripts (uso manual)

Execute a partir da raiz do **seu projeto**:

```bash
SKILL=".cursor/skills/project-manager"

# Verificar conexão
bash "$SKILL/scripts/verify-github.sh"

# Criar labels no repo
bash "$SKILL/scripts/bootstrap-labels.sh owner/repo"

# Dry-run (simula criação)
python3 "$SKILL/scripts/create-github-issues.py" \
  --dry-run --manifest .project-manager/manifest.json

# Criar issues de verdade
python3 "$SKILL/scripts/create-github-issues.py" \
  --manifest .project-manager/manifest.json
```

---

## GitHub MCP (alternativa ao `gh`)

Se preferir não usar a CLI, configure o **GitHub MCP** no Cursor:

1. **Cursor Settings → MCP → Add server**
2. Configure o servidor GitHub ([documentação MCP](https://cursor.com/docs/context/mcp))
3. O skill detecta o MCP e cria issues com as mesmas labels

---

## Estrutura deste repositório

```
├── SKILL.md                    # Instruções do agente Cursor
├── README.md                   # Este arquivo
├── config/
│   ├── labels.json             # Catálogo de labels GitHub
│   └── manifest.example.json   # Exemplo de manifest de issues
├── scripts/
│   ├── verify-github.sh        # Valida gh auth + repo
│   ├── bootstrap-labels.sh     # Cria labels no GitHub
│   └── create-github-issues.py # Publica issues em lote
├── templates/                  # Templates Epic, Feature, Task, Bug, TD
├── workflows/                  # Fluxos analyze-prd, create-issues, etc.
└── examples/
    ├── sample-prd.md           # PRD de exemplo (TaskFlow SaaS)
    └── expected-output.md      # Saída esperada completa
```

---

## Exemplo rápido

1. Clone o skill (Opção A ou B acima)
2. Abra um repo Git no Cursor
3. No chat:

```
/project-manager analyze-prd

[cole o conteúdo de examples/sample-prd.md]
```

4. Depois:

```
/project-manager create-backlog
/project-manager connect-github
/project-manager create-github-issues
```

---

## Módulos SaaS detectados automaticamente

Authentication · Authorization · User Management · Subscription · Billing · Payments · Stripe · Notifications · Audit Logs · Admin · Settings · Analytics · Reports · API · Security · Monitoring · Infrastructure · CI/CD

---

## Licença

MIT — use livremente em projetos pessoais e comerciais.

#!/usr/bin/env bash
# Registra project-manager e implement-issue no Cursor (~/.cursor/skills ou .cursor/skills).
# Uso: bash scripts/install-skills.sh [diretório-skills]
#
# Exemplos:
#   bash scripts/install-skills.sh                    # ~/.cursor/skills (pessoal)
#   bash scripts/install-skills.sh .cursor/skills     # no repo do projeto
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="${1:-$HOME/.cursor/skills}"

if [[ ! -f "$REPO_ROOT/SKILL.md" ]]; then
  echo "ERRO: Repositório project-manager inválido ($REPO_ROOT)"
  exit 1
fi

if [[ ! -f "$REPO_ROOT/implement-issue/SKILL.md" ]]; then
  echo "ERRO: Sub-skill implement-issue não encontrada em $REPO_ROOT/implement-issue/"
  exit 1
fi

mkdir -p "$SKILLS_DIR"

PM_TARGET="$SKILLS_DIR/project-manager"
II_TARGET="$SKILLS_DIR/implement-issue"

# project-manager: symlink se destino diferente do repo; senão já está no lugar (submodule)
if [[ "$(realpath "$REPO_ROOT")" != "$(realpath "$PM_TARGET" 2>/dev/null || echo "")" ]]; then
  ln -sfn "$REPO_ROOT" "$PM_TARGET"
  echo "  project-manager → $PM_TARGET"
else
  echo "  project-manager já em $PM_TARGET"
fi

ln -sfn "$REPO_ROOT/implement-issue" "$II_TARGET"
echo "  implement-issue → $II_TARGET"

echo ""
echo "OK: Skills registradas em $SKILLS_DIR"
echo "    Abra seu projeto no Cursor e use /project-manager ou /implement-issue"

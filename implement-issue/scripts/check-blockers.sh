#!/usr/bin/env bash
# Verifica se blockers de uma issue estão resolvidos.
# Uso: check-blockers.sh <issue_number> [owner/repo]
set -euo pipefail

ISSUE_NUM="${1:-}"
REPO="${2:-}"

if [[ -z "$ISSUE_NUM" ]]; then
  echo "Uso: check-blockers.sh <issue_number> [owner/repo]"
  exit 1
fi

if [[ -z "$REPO" ]]; then
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    REMOTE="$(git remote get-url origin 2>/dev/null || true)"
    REPO="$(echo "$REMOTE" | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
  fi
  REPO="${REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)}"
fi

if [[ -z "$REPO" ]]; then
  echo "ERRO: Repositório não detectado."
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "AVISO: gh não instalado — verificação de blockers ignorada."
  exit 0
fi

LABELS="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json labels -q '[.labels[].name] | join(",")' 2>/dev/null || true)"
BODY="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json body -q .body 2>/dev/null || true)"
STATE="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json state -q .state 2>/dev/null || true)"

if [[ "$STATE" == "CLOSED" ]]; then
  echo "AVISO: Issue #$ISSUE_NUM já está fechada."
  exit 0
fi

BLOCKED=0

# Label blocked
if echo "$LABELS" | grep -q 'blocked'; then
  echo "BLOQUEIO: Issue #$ISSUE_NUM tem label 'blocked'."
  BLOCKED=1
fi

# Referências "Blocked by" no corpo
BLOCKED_REFS="$(echo "$BODY" | grep -iE 'blocked by|bloqueado por|depende de' | grep -oE '#[0-9]+' || true)"

for ref in $BLOCKED_REFS; do
  REF_NUM="${ref#\#}"
  REF_STATE="$(gh issue view "$REF_NUM" --repo "$REPO" --json state,title -q '.state + "|" + .title' 2>/dev/null || echo "UNKNOWN|")"
  REF_STATUS="${REF_STATE%%|*}"
  REF_TITLE="${REF_STATE#*|}"

  if [[ "$REF_STATUS" != "CLOSED" ]]; then
    echo "BLOQUEIO: Depende de $ref ($REF_TITLE) — status: $REF_STATUS"
    BLOCKED=1
  else
    echo "OK: $ref fechada — $REF_TITLE"
  fi
done

# Referências genéricas no topo (parent epic/feature aberta)
if echo "$BODY" | grep -qiE 'epic=#[0-9]+|feature=#[0-9]+'; then
  PARENT_REFS="$(echo "$BODY" | grep -oE '(epic|feature)=#[0-9]+' | grep -oE '#[0-9]+' || true)"
  for ref in $PARENT_REFS; do
    REF_NUM="${ref#\#}"
    REF_STATE="$(gh issue view "$REF_NUM" --repo "$REPO" --json state,labels -q '.state' 2>/dev/null || true)"
    # Parent aberto é OK — só informativo
    echo "INFO: Parent $ref — state: ${REF_STATE:-unknown}"
  done
fi

if [[ "$BLOCKED" -eq 1 ]]; then
  echo ""
  echo "ERRO: Issue #$ISSUE_NUM tem blockers ativos. Resolva antes de implementar."
  exit 1
fi

echo ""
echo "OK: Issue #$ISSUE_NUM sem blockers — pronta para implementação"

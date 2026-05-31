#!/usr/bin/env bash
# Busca issue GitHub e contexto relacionado (pais, labels, body).
# Uso: fetch-issue.sh <issue_number> [owner/repo]
set -euo pipefail

ISSUE_NUM="${1:-}"
REPO="${2:-}"

if [[ -z "$ISSUE_NUM" ]]; then
  echo "Uso: fetch-issue.sh <issue_number> [owner/repo]"
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
  echo "ERRO: Repositório não detectado. Passe owner/repo como 2º argumento."
  exit 1
fi

echo "==> Repositório: $REPO"
echo "==> Issue: #$ISSUE_NUM"
echo ""

# Issue principal
if ! gh issue view "$ISSUE_NUM" --repo "$REPO" 2>/dev/null; then
  echo "ERRO: Issue #$ISSUE_NUM não encontrada em $REPO"
  exit 1
fi

echo ""
echo "==> Metadados JSON"
gh issue view "$ISSUE_NUM" --repo "$REPO" \
  --json number,title,state,labels,body,assignees,milestone,url \
  -q '{
    number: .number,
    title: .title,
    state: .state,
    url: .url,
    labels: [.labels[].name],
    milestone: .milestone.title,
    assignees: [.assignees[].login],
    body_preview: (.body | if length > 500 then .[0:500] + "..." else . end)
  }'

# Metadados project-manager no corpo
BODY="$(gh issue view "$ISSUE_NUM" --repo "$REPO" --json body -q .body 2>/dev/null || true)"
PM_META="$(echo "$BODY" | grep -oE 'project-manager:[^>]+' | head -1 || true)"
if [[ -n "$PM_META" ]]; then
  echo ""
  echo "==> project-manager metadata"
  echo "<!-- $PM_META -->"
fi

# Referências #N no corpo (possíveis pais/filhos)
REFS="$(echo "$BODY" | grep -oE '#[0-9]+' | sort -u | tr '\n' ' ' || true)"
if [[ -n "$REFS" ]]; then
  echo ""
  echo "==> Referências no corpo: $REFS"
fi

# issue-map.json local
MAP_FILE=".project-manager/issue-map.json"
if [[ -f "$MAP_FILE" ]]; then
  echo ""
  echo "==> Mapeamento local ($MAP_FILE)"
  if command -v jq >/dev/null 2>&1; then
    jq --arg n "$ISSUE_NUM" '
      to_entries[] | select(.value == ($n | tonumber) or (.value | tostring) == $n) | "  \(.key) → #\(.value)"
    ' "$MAP_FILE" 2>/dev/null || cat "$MAP_FILE"
  else
    grep -E "\"[^\"]+\":\\s*\"?${ISSUE_NUM}\"?" "$MAP_FILE" || true
  fi
fi

# Spec local
if [[ -f "$MAP_FILE" ]] && command -v jq >/dev/null 2>&1; then
  LOCAL_ID="$(jq -r --arg n "$ISSUE_NUM" '
    to_entries[] | select(.value == ($n | tonumber) or (.value | tostring) == $n) | .key
  ' "$MAP_FILE" 2>/dev/null | head -1)"
  if [[ -n "$LOCAL_ID" && -f ".project-manager/issues/${LOCAL_ID}.md" ]]; then
    echo ""
    echo "==> Spec local: .project-manager/issues/${LOCAL_ID}.md"
    head -30 ".project-manager/issues/${LOCAL_ID}.md"
    echo "..."
  fi
fi

echo ""
echo "OK: Issue #$ISSUE_NUM carregada"

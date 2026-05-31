#!/usr/bin/env bash
# Cria labels padronizadas do project-manager no repositório GitHub.
# Uso: bootstrap-labels.sh owner/repo
set -euo pipefail

REPO="${1:?Uso: bootstrap-labels.sh owner/repo}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABELS_FILE="${SCRIPT_DIR}/../config/labels.json"

if ! command -v gh >/dev/null 2>&1; then
  echo "ERRO: gh CLI necessário."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERRO: jq necessário (sudo apt install jq)."
  exit 1
fi

echo "==> Bootstrap labels em $REPO"

CREATED=0
EXISTING=0

while IFS= read -r row; do
  NAME="$(echo "$row" | jq -r '.name')"
  COLOR="$(echo "$row" | jq -r '.color')"
  DESC="$(echo "$row" | jq -r '.description')"

  if gh label list --repo "$REPO" --json name -q ".[] | select(.name==\"$NAME\") | .name" 2>/dev/null | grep -qx "$NAME"; then
    gh label edit "$NAME" --repo "$REPO" --color "$COLOR" --description "$DESC" 2>/dev/null || true
    echo "  ~ $NAME (atualizada)"
    EXISTING=$((EXISTING + 1))
  else
    gh label create "$NAME" --repo "$REPO" --color "$COLOR" --description "$DESC" 2>/dev/null
    echo "  + $NAME"
    CREATED=$((CREATED + 1))
  fi
done < <(jq -c '.labels[]' "$LABELS_FILE")

echo ""
echo "OK: $CREATED criadas, $EXISTING já existiam/atualizadas"

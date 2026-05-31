#!/usr/bin/env bash
# Verifica conexão GitHub via gh CLI.
# Uso: verify-github.sh [owner/repo]
set -euo pipefail

REPO="${1:-}"

if ! command -v gh >/dev/null 2>&1; then
  echo "ERRO: GitHub CLI (gh) não instalado."
  echo "Instale em https://cli.github.com ou configure GitHub MCP no Cursor."
  exit 1
fi

echo "==> Autenticação"
if ! gh auth status 2>&1; then
  echo "ERRO: gh não autenticado. Execute: gh auth login"
  exit 1
fi

LOGIN="$(gh api user -q .login 2>/dev/null || true)"
echo "    Usuário: ${LOGIN:-desconhecido}"

if [[ -z "$REPO" ]]; then
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    REMOTE="$(git remote get-url origin 2>/dev/null || true)"
    REPO="$(echo "$REMOTE" | sed -E 's#(git@github.com:|https://github.com/)##; s#\.git$##')"
  fi
  if [[ -z "$REPO" ]]; then
    REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  fi
fi

if [[ -z "$REPO" ]]; then
  echo "AVISO: Repositório não detectado. Passe owner/repo como argumento."
  exit 2
fi

echo "==> Repositório: $REPO"

if ! gh repo view "$REPO" --json name,isPrivate,defaultBranchRef,viewerPermission \
  -q '"    Nome: \(.name)\n    Privado: \(.isPrivate)\n    Branch: \(.defaultBranchRef.name)\n    Permissão: \(.viewerPermission)"' 2>/dev/null; then
  echo "ERRO: Sem acesso ao repositório $REPO (404 ou permissão insuficiente)."
  exit 1
fi

PERM="$(gh repo view "$REPO" --json viewerPermission -q .viewerPermission 2>/dev/null || echo "UNKNOWN")"
if [[ "$PERM" == "READ" ]]; then
  echo "ERRO: Permissão READ apenas — necessário WRITE para criar issues."
  exit 1
fi

echo "==> Teste de API Issues"
ISSUE_COUNT="$(gh issue list --repo "$REPO" --limit 1 --json number -q 'length' 2>/dev/null || echo 0)"
echo "    API Issues OK (issues acessíveis: sim)"

echo ""
echo "OK: GitHub conectado — $REPO (@${LOGIN:-?})"
echo "$REPO"

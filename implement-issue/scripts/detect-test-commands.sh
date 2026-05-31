#!/usr/bin/env bash
# Detecta comandos de teste/lint/build do projeto atual.
# Saída: linhas export TEST_CMD=..., LINT_CMD=..., etc.
set -euo pipefail

detect_npm() {
  if [[ -f package.json ]]; then
    if command -v jq >/dev/null 2>&1; then
      jq -r '.scripts // {} | to_entries[] | "\(.key)=\(.value)"' package.json 2>/dev/null | while IFS='=' read -r key val; do
        case "$key" in
          test)     echo "TEST_CMD=npm test" ;;
          lint)     echo "LINT_CMD=npm run lint" ;;
          typecheck|check) echo "TYPECHECK_CMD=npm run $key" ;;
          build)    echo "BUILD_CMD=npm run build" ;;
        esac
      done
    else
      grep -q '"test"' package.json && echo "TEST_CMD=npm test"
      grep -q '"lint"' package.json && echo "LINT_CMD=npm run lint"
    fi
  fi
}

detect_make() {
  if [[ -f Makefile ]]; then
    grep -qE '^test:' Makefile && echo "TEST_CMD=make test"
    grep -qE '^lint:' Makefile && echo "LINT_CMD=make lint"
  fi
}

detect_python() {
  if [[ -f pyproject.toml ]] || [[ -f pytest.ini ]] || [[ -d tests ]]; then
    echo "TEST_CMD=pytest"
  fi
}

detect_go() {
  [[ -f go.mod ]] && echo "TEST_CMD=go test ./..."
}

detect_rust() {
  [[ -f Cargo.toml ]] && echo "TEST_CMD=cargo test"
}

detect_php() {
  if [[ -f composer.json ]]; then
    grep -q '"test"' composer.json && echo "TEST_CMD=composer test"
    [[ -f vendor/bin/phpunit ]] && echo "TEST_CMD=vendor/bin/phpunit"
  fi
}

echo "==> Comandos detectados (cwd: $(pwd))"

FOUND="$( {
  detect_npm
  detect_make
  detect_python
  detect_go
  detect_rust
  detect_php
} 2>/dev/null | sort -u )"

if [[ -z "$FOUND" ]]; then
  echo "AVISO: Nenhum comando detectado. Leia README ou CONTRIBUTING."
else
  echo "$FOUND"
fi

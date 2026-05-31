#!/usr/bin/env python3
"""
Cria issues no GitHub a partir de .project-manager/manifest.json
Usa gh CLI — requer autenticação prévia (gh auth login).

Uso:
  python3 scripts/create-github-issues.py [--dry-run] [--manifest PATH]
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path


def run(cmd: list[str], check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, check=check)


def load_manifest(path: Path) -> dict:
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def issue_exists(repo: str, local_id: str) -> int | None:
    """Busca issue existente pelo comentário project-manager local-id."""
    result = run(
        [
            "gh", "search", "issues",
            f"repo:{repo} {local_id} in:body",
            "--json", "number,body",
            "--limit", "5",
        ],
        check=False,
    )
    if result.returncode != 0:
        return None
    items = json.loads(result.stdout or "[]")
    pattern = re.compile(rf"local-id={re.escape(local_id)}\b")
    for item in items:
        if pattern.search(item.get("body") or ""):
            return item["number"]
    return None


def create_issue(
    repo: str,
    title: str,
    body: str,
    labels: list[str],
    milestone: int | None,
    dry_run: bool,
) -> int | None:
    label_args: list[str] = []
    for label in labels:
        label_args.extend(["--label", label])

    cmd = [
        "gh", "issue", "create",
        "--repo", repo,
        "--title", title,
        "--body", body,
        *label_args,
    ]
    if milestone is not None:
        cmd.extend(["--milestone", str(milestone)])

    if dry_run:
        print(f"  [dry-run] {' '.join(cmd[:8])}... labels={labels}")
        return None

    result = run(cmd)
    url = result.stdout.strip()
    match = re.search(r"/issues/(\d+)", url)
    if not match:
        print(f"  ERRO: resposta inesperada: {url}", file=sys.stderr)
        return None
    return int(match.group(1))


def resolve_milestone_number(repo: str, title: str | None) -> int | None:
    if not title:
        return None
    result = run(
        [
            "gh", "api", f"repos/{repo}/milestones",
            "--jq", f'.[] | select(.title=="{title}") | .number',
        ],
        check=False,
    )
    num = result.stdout.strip()
    return int(num) if num.isdigit() else None


def substitute_refs(body: str, id_map: dict[str, int]) -> str:
    for local_id, github_num in id_map.items():
        body = body.replace(f"#{local_id}", f"#{github_num}")
        body = body.replace(f"Epic {local_id}", f"Epic #{github_num}")
        body = body.replace(f"Feature {local_id}", f"Feature #{github_num}")
    return body


def main() -> int:
    parser = argparse.ArgumentParser(description="Cria GitHub issues do manifest project-manager")
    parser.add_argument("--dry-run", action="store_true", help="Simula sem criar")
    parser.add_argument(
        "--manifest",
        default=".project-manager/manifest.json",
        help="Caminho do manifest JSON",
    )
    args = parser.parse_args()

    manifest_path = Path(args.manifest)
    if not manifest_path.exists():
        print(f"ERRO: manifest não encontrado: {manifest_path}", file=sys.stderr)
        print("Gere o manifest antes com create-backlog + create-github-issues workflow.", file=sys.stderr)
        return 1

    manifest = load_manifest(manifest_path)
    repo = manifest.get("repo") or manifest.get("full_name")
    if not repo:
        print("ERRO: manifest.repo obrigatório", file=sys.stderr)
        return 1

    skill_root = Path(__file__).resolve().parent.parent
    issues_dir = manifest_path.parent / "issues"

    milestone_num = resolve_milestone_number(repo, manifest.get("milestone"))

    print(f"==> Repositório: {repo}")
    print(f"==> Issues no manifest: {len(manifest.get('issues', []))}")
    if args.dry_run:
        print("==> Modo dry-run")

    id_map: dict[str, int] = {}
    results: list[dict] = []

    for item in manifest.get("issues", []):
        local_id = item["local_id"]
        title = item["title"]
        labels = item.get("labels", [])

        existing = issue_exists(repo, local_id)
        if existing:
            print(f"  = {local_id} já existe como #{existing}")
            id_map[local_id] = existing
            results.append({"local_id": local_id, "github_number": existing, "status": "existing"})
            continue

        body_file = item.get("body_file")
        if body_file:
            body_path = Path(body_file)
            if not body_path.is_absolute():
                body_path = manifest_path.parent.parent / body_file
                if not body_path.exists():
                    body_path = issues_dir / Path(body_file).name
            body = body_path.read_text(encoding="utf-8")
        else:
            body = item.get("body", "")

        body = substitute_refs(body, id_map)

        if f"local-id={local_id}" not in body:
            meta = f"<!-- project-manager: type={item.get('type','task')} | local-id={local_id} -->\n\n"
            body = meta + body

        print(f"  + {local_id}: {title[:60]}...")
        number = create_issue(repo, title, body, labels, milestone_num, args.dry_run)

        if number:
            id_map[local_id] = number
            results.append({"local_id": local_id, "github_number": number, "status": "created"})
            time.sleep(0.5)
        elif args.dry_run:
            id_map[local_id] = 0
            results.append({"local_id": local_id, "github_number": None, "status": "dry-run"})

    map_path = manifest_path.parent / "issue-map.json"
    map_data = {
        "repo": repo,
        "milestone": manifest.get("milestone"),
        "mapping": {r["local_id"]: r["github_number"] for r in results},
        "details": results,
    }
    if not args.dry_run:
        map_path.write_text(json.dumps(map_data, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"\nOK: issue-map salvo em {map_path}")

    created = sum(1 for r in results if r["status"] == "created")
    existing = sum(1 for r in results if r["status"] == "existing")
    print(f"\nResumo: {created} criadas, {existing} já existiam")
    return 0


if __name__ == "__main__":
    sys.exit(main())

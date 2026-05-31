# Exemplos de prompts

> Skill incluída em `project-manager/implement-issue/`. Instale com `bash scripts/install-skills.sh`.

## Implementação completa (task)

```
/implement-issue #145
```

Ou em linguagem natural:

```
Implemente a task #145 deste repositório.
Use a skill implement-issue: leia a issue, verifique blockers, crie branch,
implemente, teste e abra PR fechando #145.
```

---

## Apenas validar critérios (sem codar)

```
/implement-issue validate #145
```

Útil para QA ou revisar se PR existente cobre a issue.

---

## Bug com reprodução

```
/implement-issue #201

Reproduza o bug descrito na issue, escreva teste de regressão,
corrija e abra PR com Fixes #201.
```

---

## Feature (redirecionar para tasks)

```
/implement-issue #102
```

Comportamento esperado do agente:

1. Detectar que #102 é `feature`
2. Listar tasks filhas abertas (#110, #111, #112)
3. Sugerir implementar uma task por vez ou perguntar qual priorizar

---

## Após PR — deixar merge-ready

```
Use babysit no PR #88 até CI verde e comentários resolvidos.
```

---

## Fluxo sprint (com project-manager)

```
/project-manager sprint-planning

Implemente as tasks comprometidas na sprint, uma por conversa:
- /implement-issue #110
- /implement-issue #111
```

---

## Issue bloqueada (resposta esperada)

Se #112 tem `Blocked by #110` e #110 está aberta:

```
/implement-issue #112
```

Agente deve **parar** e reportar:

> Issue #112 bloqueada por #110 (aberta). Implemente #110 primeiro.

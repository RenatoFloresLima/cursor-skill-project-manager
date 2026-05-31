# PRD — TaskFlow SaaS

**Produto:** TaskFlow — plataforma de gestão de tarefas para equipes remotas  
**Versão do documento:** 1.0  
**Autor:** Product Team  
**Data:** 30/05/2026  
**Status:** Aprovado para MVP

---

## 1. Visão do produto

TaskFlow é um SaaS B2B que permite equipes de 5–50 pessoas organizarem projetos, tarefas e prazos em um único lugar, com foco em simplicidade e colaboração em tempo real.

**Problema:** equipes usam planilhas e ferramentas fragmentadas; falta visibilidade de carga e accountability.

**Solução:** workspace colaborativo com boards Kanban, atribuição de tarefas, notificações e planos pagos por assento.

---

## 2. Objetivos de negócio (6 meses)

| Objetivo | Meta |
|----------|------|
| Usuários registrados | 500 |
| Conversão trial → pago | ≥ 8% |
| MRR | R$ 25.000 |
| Churn mensal | < 5% |
| NPS | ≥ 45 |

---

## 3. Personas

### P1 — Ana, Tech Lead (decisor)
- Gerencia equipe de 12 devs
- Precisa de visibilidade de sprint e blockers
- Orça ferramentas; sensível a preço por assento

### P2 — Bruno, Developer (usuário diário)
- Atualiza status de tarefas várias vezes ao dia
- Quer notificações relevantes, não spam
- Usa desktop e mobile

### P3 — Carla, Admin de workspace (owner)
- Convida membros, gerencia billing
- Precisa exportar dados e entender uso da equipe

---

## 4. Escopo MoSCoW

### Must have (MVP — Release R1)
- Cadastro e login (e-mail + senha)
- Recuperação de senha
- Workspace com convite por e-mail
- CRUD de projetos e tarefas
- Board Kanban (colunas: Backlog, Em progresso, Concluído)
- Atribuição de tarefa a membro
- Plano Free (3 usuários) e Pro (ilimitado, R$ 29/assento/mês)
- Checkout Stripe (cartão)
- Webhook Stripe para sync de assinatura
- E-mail transacional (boas-vindas, convite, reset senha)
- Dashboard admin: membros, plano atual, uso básico

### Should have (R2 — GA)
- Notificações in-app
- Preferências de notificação
- Audit log de ações admin
- Relatório exportável CSV (tarefas concluídas por período)
- OAuth Google login

### Could have (backlog)
- API pública REST
- Integração Slack
- Mobile app nativo

### Won't have (v1)
- Gantt chart
- Time tracking
- White-label

---

## 5. Requisitos funcionais

### RF-01 — Autenticação
- RF-01.1: Cadastro com e-mail, senha (mín. 8 chars, 1 número, 1 especial)
- RF-01.2: Login com sessão JWT (access 15min, refresh 7 dias)
- RF-01.3: Logout invalida refresh token
- RF-01.4: Reset senha via link e-mail (expira 1h)

### RF-02 — Workspace e usuários
- RF-02.1: Usuário cria workspace no onboarding
- RF-02.2: Owner convida por e-mail (link expira 7 dias)
- RF-02.3: Roles: Owner, Admin, Member
- RF-02.4: Owner pode remover membros

### RF-03 — Projetos e tarefas
- RF-03.1: CRUD projeto (nome, descrição, cor)
- RF-03.2: CRUD tarefa (título, descrição, assignee, due date, coluna)
- RF-03.3: Drag-and-drop entre colunas Kanban
- RF-03.4: Filtro por assignee e due date

### RF-04 — Assinaturas e billing
- RF-04.1: Trial Pro 14 dias sem cartão
- RF-04.2: Upgrade para Pro via Stripe Checkout
- RF-04.3: Downgrade ao fim do período pago
- RF-04.4: Limite Free: bloquear convite acima de 3 membros
- RF-04.5: Portal Stripe para gestão de cartão

### RF-05 — Notificações (R2)
- RF-05.1: E-mail quando tarefa atribuída
- RF-05.2: In-app notification center
- RF-05.3: Usuário desliga categorias de notificação

### RF-06 — Administração
- RF-06.1: Painel admin com lista de membros e roles
- RF-06.2: Exibir plano, próxima cobrança, histórico de faturas (link Stripe)

---

## 6. Requisitos não-funcionais

| ID | Requisito |
|----|-----------|
| RNF-01 | p95 API < 300ms (exceto checkout) |
| RNF-02 | Disponibilidade 99.5% |
| RNF-03 | Dados em repouso criptografados (AES-256) |
| RNF-04 | LGPD: export e delete account em até 30 dias |
| RNF-05 | WCAG 2.1 AA nos fluxos principais |
| RNF-06 | Logs estruturados JSON; correlation ID por request |
| RNF-07 | CI: lint + test + deploy preview por PR |

---

## 7. Integrações

| Serviço | Uso |
|---------|-----|
| Stripe | Checkout, Customer, Subscription, Portal, Webhooks |
| SendGrid | E-mail transacional |
| PostgreSQL (Neon) | Banco principal |
| Sentry | Error tracking |
| GitHub Actions | CI/CD |

---

## 8. Stack técnica (constraint)

- Frontend: Next.js 15, React, Tailwind
- Backend: Next.js API Routes + tRPC
- ORM: Drizzle
- Auth: JWT próprio (sem Clerk/Auth0 no MVP)
- Hosting: Vercel

---

## 9. Bugs conhecidos (ambiente staging atual)

**BUG-01:** Ao arrastar tarefa rapidamente entre colunas, status occasionally reverte após refresh (race condition suspect).

**BUG-02:** E-mail de convite em pt-BR chega com subject em inglês ("You're invited").

---

## 10. Dívida técnica conhecida

- Auth e billing compartilham tabela `users` sem separação clara de concerns
- Testes E2E inexistentes; apenas unitários parciais
- Webhook Stripe sem idempotency key — risco de duplicate subscriptions em retry

---

## 11. Riscos

| Risco | Mitigação |
|-------|-----------|
| Atraso integração Stripe | Spike técnico Sprint 1 |
| LGPD: delete account não especificado em detalhe | Consultar jurídico; default anonimização |
| Performance Kanban com 500+ tarefas | Paginação virtual (R2) |

---

## 12. Cronograma desejado

| Marco | Data alvo |
|-------|-----------|
| Alpha interno (R0) | 15/07/2026 |
| Beta fechado MVP (R1) | 01/09/2026 |
| GA v1.0 (R2) | 15/10/2026 |

---

## 13. Métricas de sucesso do MVP

- Usuário completa onboarding (workspace + 1 projeto + 3 tarefas) em < 10 min
- Checkout Pro concluído em < 3 min
- Zero incidentes P0 de billing em 30 dias pós-launch

---

## 14. Open questions

1. MFA obrigatório para Admin no MVP? (sugestão: não, R2)
2. Faturamento em BRL apenas ou multi-currency? (sugestão: BRL MVP)
3. Retenção de audit logs: 90 dias ou 1 ano? (sugestão: 90 dias MVP)

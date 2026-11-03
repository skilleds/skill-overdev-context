---
description: Gera o handoff de contexto (context.md + checklist.md) no archive, SEM compactar
---

Gere o handoff da montagem de contexto **sem** compactar — pra fim de sessão ou troca de tarefa:

1. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-context.md` — estado da Fase 0: etapas
   fechadas (decisões / grafo / plano / checklist / briefing), decisões `D1..Dn` colhidas, nós do
   grafo ancorados, on-holds abertos (+ perguntas de `PERGUNTAS-OVERDEV.txt`), decisões, onde parou.
2. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-checklist.md` — **FEITO vs EM ABERTO** das
   etapas da fundação (o que falta antes de o gate da Fase 0 fechar e soltar o `/eng-overdev`).

Piso 26: handoff a cada 6 h de trabalho ativo e relatório a cada 30 min em `<projeto>_archive/relatorios/`
(carimbos em `.ritmo.json`); depois de gravar, **commit + push** do archive (piso 22: `HEAD == origin`).

Não rode `/compact` — só arquiva.

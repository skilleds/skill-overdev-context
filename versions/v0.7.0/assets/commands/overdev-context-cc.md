---
description: Context Compact — gera handoff (context.md + checklist.md) no <projeto>_archive e compacta
---

Antes de compactar, **arquive o handoff** (não perca o estado da montagem de contexto):

1. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-context.md` — estado da Fase 0: quais das 5
   etapas fecharam (decisões / grafo / plano / checklist / briefing), decisões `D1..Dn` já
   colhidas, nós do grafo ancorados, on-holds abertos, onde parou.
2. `<projeto>_archive/context/<YYYY-MM-DD-HH-MM-SS>-checklist.md` — **FEITO vs EM ABERTO** das
   etapas da fundação (o que da Fase 0 falta montar antes de soltar o laço).
   Atualize `ultimo_handoff` em `.ritmo.json` (piso 26) e faça commit + push do archive (piso 22).
3. Só então rode `/compact` (foco na tarefa corrente).

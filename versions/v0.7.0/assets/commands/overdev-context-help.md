---
description: schematize-overdev-context — lista todos os comandos disponíveis e o que cada um faz
---

Liste os comandos do **schematize-overdev-context** instalados (`/overdev-context-*`), com 1
linha cada:

- `/overdev-context-help` — esta lista.
- `/overdev-context-build` — **monta a Fase 0 / fundação** do overdev, em 5 etapas: colhe as
  DECISÕES acordadas (`.schematize/overdev/DECISOES.md`, ADR-lite) → ancora no GRAFO do índice (§39) →
  escreve o PLAN pesado (`.schematize/overdev/PLAN.md`) → deriva o CHECKLIST exaustivo por contagem
  (`.schematize/overdev/CHECKLIST.md`, convenção de 3 classes `- [ ]`/`- [H ]`/`- [~]`) → entrega o
  DOCUMENTO DE CONTEXTO GERAL (briefing) no archive. **Monta o que o `/eng-overdev` consome; não
  entra no laço.**
- `/overdev-context-load` — carrega à força TODO o corpo normativo (contexto, decisões,
  plano/checklist, briefing) e passa a aplicá-lo.
- `/overdev-context-claude` — cria ou mescla o `CLAUDE.md` sempre-on de montagem de contexto na
  raiz do repo.
- `/overdev-context-cc` — context compact: gera handoff no archive e roda `/compact`.
- `/overdev-context-handoff` — gera o handoff (context.md + checklist.md) sem compactar.

Depois da lista, lembre a **regra de ouro**: *fundação antes do laço.* Esta skill **MONTA** o
contexto (decisões → grafo → plano → checklist → briefing); quem **CONSOME** e tickeia item a
item é o `/eng-overdev` (motor `schematize overdev start`). Decisão só entra se **acordada** (com
origem); ambíguo vira `- [~]` on-hold, nunca decisão de fachada; o checklist é **exaustivo por
contagem** na convenção de 3 classes (máquina `- [ ]` / humano `- [H ]` / on-hold `- [~]`). Detalhe
normativo em `references/` da skill `schematize-overdev-context`; a base (overdev §0, índice §39,
DoD §35, archive §28) é a `schematize-engineering`; a `schematize-audit` depois cobra que fechou.

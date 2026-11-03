---
description: schematize-overdev-context — carrega à força TODO o corpo normativo (contexto/5 etapas, decisões, plano/checklist, briefing) e passa a aplicá-lo
---

Carregue **à força** e passe a aplicar **integralmente** os Padrões de Montagem de Contexto de
Overdev da Casa (skill `schematize-overdev-context`) neste projeto. A partir de agora, nesta
sessão, isto **não é opcional**.

1. **Leia agora, na íntegra, TODOS os references** — não trabalhe de memória. Caminho:
   `.claude/skills/schematize-overdev-context/references/*.md` (projeto) ou
   `~/.claude/skills/schematize-overdev-context/references/*.md` (global):
   - `contexto.md` — o **método completo**: as 5 etapas (decisões → grafo → plano → checklist →
     briefing), o **gate da Fase 0**, o que a skill NÃO faz (não tickeia), quando rodar.
   - `decisoes.md` — etapa 1 a fundo: varrer a sessão/repo, o que conta como decisão **acordada**
     (vs abandonada/ambígua), o **formato ADR-lite**, o mapa decisão→item, onde gravar.
   - `plano-checklist.md` — etapas 3+4: anatomia do **PLAN pesado** (escopo, itens verificáveis
     com nó+prova+deps+risco, ordem, paralelismo, cobertura, riscos, DoD) e a **derivação do
     CHECKLIST** exaustivo por contagem, com a **convenção de 3 classes** (`- [ ]` máquina /
     `- [H ]` humano / `- [~]` on-hold) detalhada.
   - `briefing.md` — etapa 5: a **anatomia do Documento de Contexto Geral** (objetivo, decisões,
     grafo, plano, checklist, riscos, DoD, on-holds), onde grava e como o `/eng-overdev` + o
     painel consomem.

2. **Confirme ao usuário** que leu (1 linha por arquivo).

3. Deste ponto, aplique como regra inegociável: **fundação antes do laço** (5 etapas antes de
   qualquer item); **decisão só se acordada** com origem (ambíguo → on-hold, nunca de fachada);
   **plano ancorado no grafo real** (sem índice → gerá-lo é o 1º item); **checklist exaustivo por
   contagem** na **convenção de 3 classes**; **rastreabilidade** decisão→item→nó; **saída durável**
   em `.schematize/overdev/` + `<projeto>_archive/overdev/`; e a fronteira dura — esta skill **MONTA**, o
   `/eng-overdev` **CONSOME** (não tickeie, não declare "pronto").

4. **Atualize o `CLAUDE.md` da raiz** com `assets/CLAUDE.md` da skill (mescla se já houver de
   outra skill) — é o `/overdev-context-claude`.

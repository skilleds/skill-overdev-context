---
description: schematize-overdev-context — monta a Fase 0 / fundação de um overdev: colhe as DECISÕES acordadas → ancora no GRAFO do índice → PLAN pesado → CHECKLIST exaustivo (3 classes) → DOCUMENTO DE CONTEXTO GERAL (briefing). MONTA o que o /eng-overdev CONSOME; NÃO entra no laço.
argument-hint: "<objetivo do overdev> [| dir do archive, ex: <projeto>_archive]"
---

Monte o **contexto geral do overdev** — a **Fase 0 / fundação** (`references/contexto.md`).
Rode as **cinco etapas em ordem**. Isto **funda** o trabalho; **não tickeia** item nem entra no
laço (isso é o `/eng-overdev`). Só passe o bastão quando o gate da Fase 0 (§6) fechar.

## 1. Colher as DECISÕES acordadas (`references/decisoes.md`)
Varra a **sessão/conversa inteira** e o **repo/archive** e extraia as decisões **fechadas** (não
as abandonadas nem as ambíguas). Formato **ADR-lite**, numeradas `D1..Dn`:
`Decisão · Motivo · Alternativa descartada · Origem (onde no contexto/repo) · Reversibilidade`.
- Grava em `.schematize/overdev/DECISOES.md` (+ espelho `<projeto>_archive/overdev/`).
- **Ambíguo/em aberto NÃO vira decisão** — vira candidato a `- [~]` on-hold (§4). Decisão de
  fachada é pior que decisão ausente.
- **Default assumido** (custo de errar reversível) entra explícito como decisão-com-default.

## 2. Ancorar no GRAFO do índice (`references/contexto.md` §2)
Rode/leia `/eng-index` (§39): `MAPA.md` + adjacência `A -> B` em `<projeto>_archive/index/`. O
plano vai apontar, por item, o(s) **nó(s)** (`arquivo:linha`) e as **arestas** afetadas. **Sem
índice? gerá-lo é o 1º item do checklist** — não se planeja cego.

## 3. Planejar PESADO → `.schematize/overdev/PLAN.md` (`references/plano-checklist.md` Parte A)
Escopo **entra / NÃO entra** (ancorado nas decisões); decomposição em itens **verificáveis** do tamanho de
**uma micro-task de Sonnet** (cada um: **nó + prova + dependências + risco**); **ordem topológica**; **paralelismo** (≥3 independentes
→ fan-out `/eng-orchestrate`); **cobertura do grafo** (nós tocados vs devidos); **riscos**;
**pontos de parada legítima**; **DoD** (§35) + archive (§28). Espelhe no archive.

## 4. Derivar o CHECKLIST → `.schematize/overdev/CHECKLIST.md` (`references/plano-checklist.md` Parte B)
Projeção **executável** do plano, **exaustiva por contagem** (1 item/linha, cada um com **como
provar**). Convenção de **3 classes**:
- `- [ ]`/`- [x]` = **máquina** (fecha com teste/gate); `- [H ]`/`- [H x]` = **humano** (aceite/
  revisão — a máquina **não** auto-fecha); `- [~]` = **on-hold/parkeado** (conta como aberto; sem caminho → `BLOCKED`).
- Cubra testes, edge cases, erro/loading/vazio, doc-comment + índice/MAPA (§39), DoD, archive.
- **Bloco-piso (pisos 20-29, `references/plano-checklist.md` B.1):** push + `HEAD == origin` (22), relatório 30 min/
  handoff 6 h + `custos/` (26) e, se couber, matriz de acesso (20), passkey (21), gatilho de CI sem PR (27),
  `resilience.yml` + 7 testes (28) — itens `[sonnet]` com `[piso]` e `prova:`.
- Checklist do usuário **incorporado inteiro** (nunca resumido). **Rastreabilidade** decisão→item→nó.
- **Tag de executor por item:** `[sonnet]` (default) ou `[opus: <motivo>]` (só após escalada
  registrada); cada item = **uma micro-task de Sonnet** (entrada/saída/arquivo-alvo/prova na linha).
  "Decidir arquitetura" não é item — o desenho é seu (orquestrador), feito aqui na Fase 0. Ex.:
  `- [ ] [sonnet] Implementar validateToken() em auth/token.go (prova: go test ./auth) [D3]`.
  Piso: `schematize-engineering` → `references/orquestracao.md` §9.
- Espelhe em `<projeto>_archive/overdev/OBJETIVO.md`.

## 5. Entregar o BRIEFING (`references/briefing.md`)
**Documento de Contexto Geral** coeso: objetivo + escopo + decisões (resumo+link) + grafo/cobertura
+ plano (resumo+link) + checklist (contagem por classe + mapa decisão→item→nó) + riscos + DoD +
on-holds. Grava em `<projeto>_archive/overdev/<YYYY-MM-DD>-CONTEXTO.md`.

## 6. Gate da Fase 0 e passagem de bastão
**Commit + push do `<projeto>_archive` (repo privado) com a Fase 0 espelhada** (piso 22). Rode o gate verificável: `bash .claude/skills/schematize-overdev-context/scripts/check-contexto.sh .schematize/overdev <projeto>_archive` — exit 0 ou volte e corrija a falha impressa. Ele reprova stub: PLAN sem Entra/NÃO entra/Riscos/DoD, item sem `prova:` ou sem `[D<n>]`/`[piso]`, `[~]` sem pergunta, espelho divergente, bloco-piso ausente e archive não commitado/empurrado (`--sem-git` só para ensaio).
Só está pronto quando: `DECISOES.md` colhido · grafo carregado (ou ausência + item de gerá-lo) ·
`PLAN.md` pesado · `CHECKLIST.md` derivado (3 classes, rastreável) · briefing gravado. Fechado:
**reporte** (objetivo, contagem do checklist por classe, decisões-chave + defaults, perguntas
parkeadas) e **passe o bastão**: `schematize overdev start "<objetivo>"` + `/eng-overdev` assumem
o laço. **NÃO entre no laço aqui.**

> Regra de ouro: esta skill **MONTA** o contexto; o `/eng-overdev` **CONSOME**. Não tickeie, não
> declare "pronto", não abra pool de pergunta bloqueante (dúvida → `- [~]` + `PERGUNTAS-OVERDEV.txt`).

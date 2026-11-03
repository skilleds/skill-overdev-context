# Etapa 5 — o DOCUMENTO DE CONTEXTO GERAL (o briefing do overdev)

> Os quatro artefatos anteriores (`DECISOES.md`, o grafo, `PLAN.md`, `CHECKLIST.md`) são a
> matéria-prima. O briefing é a **vista coesa** por cima deles: o documento único que amarra
> objetivo + decisões + grafo + plano + checklist + riscos, e que o `/eng-overdev` **abre pra
> trabalhar** — e o humano lê pra acompanhar sem ter que reconstruir tudo de cabeça.

O briefing **não substitui** os artefatos de control-plane (`.schematize/overdev/*`) — o hook do overdev
continua lendo o `CHECKLIST.md`, não o briefing. O briefing é o **registro durável e legível** que
dá sentido ao conjunto. Grava em `<projeto>_archive/overdev/<YYYY-MM-DD>-CONTEXTO.md` (§28).

## Anatomia (a ordem importa: do "por quê" ao "como provar")

### 1. Cabeçalho e objetivo
- **Objetivo:** a frase acionável (a mesma do topo do `PLAN.md`).
- **Data, projeto, autor do run.** Link pro `PLAN.md` e `CHECKLIST.md` em `.schematize/overdev/`.
- **Estado da fundação:** o gate da Fase 0 fechou? (checklist dos 5 itens do gate — `contexto.md`
  §6 — todos verdes).

### 2. Escopo (entra / NÃO entra)
Copiado/resumido do plano. É a primeira coisa que evita o inchaço no laço: quem for tickar sabe
**onde parar**.

### 3. Decisões (resumo + link)
Tabela enxuta das decisões `D1..Dn` (`Decisão · Motivo · Origem`), com link pro `DECISOES.md`
completo. Destaque as **irreversíveis** e os **defaults assumidos** (o que pode precisar de
ajuste se o usuário discordar).

### 4. Grafo e cobertura
- Os **nós** que o objetivo toca (do índice §39), com `arquivo:linha`.
- **Cobertura:** nós tocados pelos itens vs nós que deveriam ser (do `PLAN.md` A.4) — e que o
  buraco foi fechado.
- Se o índice não existia, registre que **gerá-lo é o 1º item** do checklist.

### 5. Plano (resumo + link)
As fases em ordem topológica, o que é **paralelizável** (unidades de fan-out `/eng-orchestrate`),
e os pontos de parada legítima. Link pro `PLAN.md`.

### 6. Checklist (estado inicial)
- **Contagem por classe:** quantos `- [ ]` (máquina), `- [H ]` (humano), `- [~]` (on-hold). Esse é
  o "tamanho" honesto do trabalho.
- O **mapa decisão→item→nó** (a tabela de rastreabilidade fechada).
- Link pro `CHECKLIST.md` control-plane.

### 7. Riscos e DoD
Riscos do plano (com mitigação) + a **Definition of Done** do objetivo (§35) + o que conta como
archive (§28). É o que o laço vai ter que satisfazer pra fechar de verdade.

### 8. Perguntas parkeadas (on-hold)
Lista das ambíguas viradas `- [~]`, cada uma com a pergunta que foi/será pra
`./PERGUNTAS-OVERDEV.txt`. Deixa explícito o que **não** está decidido — honestidade sobre os
buracos, não escondê-los.

## Como o briefing é CONSUMIDO

- **`/eng-overdev` (o laço):** ao iniciar/retomar, abre o briefing pra reconstruir o contexto
  rápido, e trabalha sobre o `CHECKLIST.md` control-plane. O motor `schematize overdev start
  "<objetivo>"` grava os artefatos da Fase 0 em `.schematize/overdev/`; o briefing é o registro durável
  espelhado no archive.
- **O painel `schematize`** (`schematize panel`, em construção): renderiza decisões, plano,
  progresso do checklist (feitos/abertos/on-hold por classe) e a **tela de grafos** a partir
  desses arquivos. O briefing é a fonte legível; o painel é a vista interativa. Ambos são
  **read-mostly**: o juiz do "terminou" é o checklist + gate, não a tela.
- **A `schematize-audit`** (depois): usa o briefing + os artefatos pra **cobrar** que o fundado
  fechou — cada decisão virou item feito?, o checklist foi sanado?, on-hold foi respondido? Um
  briefing bem-amarrado é o que dá à auditoria um rastro auditável.

## O que o briefing declara sobre EXECUÇÃO (custo)

O briefing entregue ao laço deixa **explícito** o piso "Orquestrador não desenvolve; subagent
barato executa" (`schematize-engineering` → `references/orquestracao.md` §9): o **principal não
desenvolve — só despacha e revisa**; cada item do CHECKLIST (já com tag `[sonnet]`/`[opus:
motivo]`) é executado por subagent `sonnet`; a escada de falha é **sonnet → correção pelo mesmo
subagent (≤2 rodadas) → re-decompor → opus** (motivo no checkpoint). Resuma isto em 2–3 linhas no
cabeçalho do briefing e referencie a §9; não duplique o texto. Declare também a regra de **frota
ociosa** (`schematize-engineering` → `references/orquestracao.md` §9.6): agent idle com pendência executável volta ao trabalho; pendência
que depende de outro agent → mata e enfileira com gatilho de dependência; terminou → mata; a
varredura roda a cada item fechado no laço.

**Ritmo de registro (piso 26):** o briefing declara ao laço, em 1 linha, que em trabalho ativo há
**relatório a cada 30 min** em `<archive>/relatorios/` (com o custo lido de `<archive>/custos/`) e **handoff a
cada 6 h** (e em fim de sessão/marco/compact), ambos commitados e empurrados na hora; aponte a engineering
(`schematize-engineering -> references/orquestracao.md`), não copie a regra.

## Passagem de bastão (fim da montagem)

Com o briefing gravado e o gate da Fase 0 fechado (`contexto.md` §6), a montagem **terminou**.
Reporte ao usuário: o objetivo, a contagem do checklist por classe, as decisões-chave (e defaults
assumidos), as perguntas parkeadas, e o **comando pra soltar o laço** (`schematize overdev start
"<objetivo>"` + `/eng-overdev`). **Esta skill não entra no laço** — ela entrega o contexto e passa
o bastão.

## Piso da etapa

1. Briefing **coeso** que amarra objetivo + escopo + decisões + grafo + plano + checklist +
   riscos + DoD + on-holds — não um dump dos arquivos, uma **vista** deles.
2. Gravado em `<projeto>_archive/overdev/<data>-CONTEXTO.md` (§28) — durável, legível, linkando os
   artefatos de control-plane.
3. **Read-mostly:** o briefing informa; o **checklist + gate** é que decidem "terminou".
4. Fecha com **passagem de bastão** explícita pro `/eng-overdev` — a skill monta, não consome.

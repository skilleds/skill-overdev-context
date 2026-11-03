# CLAUDE.md — Montagem de Contexto do Overdev (sempre on)

> Copie para a **raiz do repositório** e ajuste `<project>`. Fica pinado no contexto de toda
> tarefa e garante o piso mesmo quando a skill `schematize-overdev-context` não dispara sozinha.
> Em repo multi-skill, use **junto** com os `CLAUDE.md` das skills de engenharia (rode
> `/overdev-context-claude` que mescla, sem sobrescrever os outros blocos).

## Regra mestre

Nenhum overdev começa a tickar item **sem a Fase 0 montada**. Antes do laço, o trabalho é
**fundado**: decisões acordadas colhidas, grafo do índice ancorado, plano pesado escrito,
checklist exaustivo derivado, briefing entregue. Esta skill **MONTA** esse contexto; quem o
**CONSOME** e executa o laço é o `/eng-overdev` (motor `schematize overdev start`). Em conflito
entre "abre o checklist e sai codando" e este piso, **o piso vence**. Consulte o reference antes
de agir — não trabalhe de memória.

## Pisos inegociáveis (VETADO — sem exceção)

1. **Fundação ANTES do laço.** Nenhum item é tickado antes das cinco etapas fecharem (decisões →
   grafo → plano → checklist → briefing). Codar sem fundação é a macaquice que esta skill mata.
   Esta skill **funda**; o `/eng-overdev` **tickeia**.
2. **Decisão só entra se ACORDADA — com origem rastreável.** Vão pro `.schematize/overdev/DECISOES.md` só as
   decisões **fechadas** (decisão · motivo · alternativa descartada · **origem**). O que ficou
   ambíguo/em aberto **não vira decisão** — vira `- [~]` on-hold. Decisão de fachada é pior que
   decisão ausente.
3. **Plano ancorado no GRAFO real.** Cada item aponta o(s) nó(s) (`arquivo:linha`) e as arestas
   afetadas. Sem índice (§39)? **gerá-lo é o 1º item** do checklist — não se planeja cego.
4. **Checklist exaustivo POR CONTAGEM, cada item com como provar.** Um item por linha, pequeno,
   com o teste/comando/gate que o fecha. Checklist magro = "terminei" precoce embutido. Checklist
   do usuário **incorporado inteiro**, nunca resumido.
5. **Convenção de 3 classes.** `- [ ]`/`- [x]` = **máquina** (fecha com prova automática);
   `- [H ]`/`- [H x]` = **humano** (aceite/revisão — a máquina **não** auto-fecha); `- [~]` =
   **on-hold** (conta como aberto; sem caminho → `BLOCKED`). Cada classe fecha do seu jeito.
6. **Rastreabilidade decisão→item→nó.** Cada decisão vira ≥1 item; cada item aponta a decisão e o
   nó. Decisão sem item é esquecida; item sem decisão/nó é solto.
7. **Saída durável no archive + control-plane.** `.schematize/overdev/` (`DECISOES.md`, `PLAN.md`,
   `CHECKLIST.md` — trate como `.git`, **gitignore**) **e** espelho em `<project>_archive/overdev/`
   (§28). O briefing vai pro archive. Sem archive, a fundação não aconteceu.
8. **Esta skill MONTA, não CONSOME.** Não tickeia, não abre pool de pergunta bloqueante (dúvida →
   `- [~]` + `./PERGUNTAS-OVERDEV.txt`), não declara "pronto". Fechado o gate da Fase 0, passa o
   bastão pro `/eng-overdev`.

9. <!-- herdado:engineering/orquestracao:curto -->**Orquestrador não desenvolve; subagent barato executa.** O agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para o executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código; falhou → mesmo subagent corrige, até 2 rodadas) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo) → `park`; **visual vai direto ao Codex**; **imagem nunca pelo Claude: detectar Codex/Gemini e perguntar ao usuário qual usar (Codex é a sugestão), nunca API de imagem paga**; papéis em `agentes.toml`. No overdev, cada item do checklist vai a um subagent e o principal revisa antes do `- [x]`. **Sem frota ociosa:** idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata (§9.6). Detalhe: `schematize-engineering` → `references/orquestracao.md` §9.<!-- /herdado -->
   A Fase 0 aplica isto assim: decompõe PLAN/CHECKLIST em itens de **uma micro-task de Sonnet**, cada um com tag `[sonnet]` (default) ou `[opus: <motivo>]` (só após escalada registrada); "decidir arquitetura" não é item — o desenho é do orquestrador; o briefing declara a escada.

<!-- herdado:engineering/pisos-22-29:bloco -->**Herda os pisos 22–29 da `schematize-engineering`** (texto completo em `assets/CLAUDE.md` dela): 22 tudo no git — sem remote, push falho ou HEAD≠origin a demanda NÃO se conclui; 23 deploy só do git (VETADO scp/rsync/tar|ssh/docker save|load/git bundle); 24 o ops é o gate da IA — a IA nunca muda a VPS direto nem escreve SQL, só operação nomeada (`ssh vps "ops <op>"`); 25 sem agents inúteis (entregou, morreu); 26 relatório a cada 30 min e handoff a cada 6 h; 27 CI remoto só antes do hml, a pedido ou em tag (`workflow_dispatch` + `hml-*`/`v*`; VETADO `pull_request`, `push` em branch, `workflow_run`, cron sem justificativa); 28 microserviço autônomo (fila durável + 7 testes de resiliência); 29 build/teste na máquina dev/hml quando existe (ponte só no workspace de build, nunca prd) + higiene (`scripts/higiene.sh`).<!-- /herdado -->

## Como se monta aqui

- **`/overdev-context-build`:** roda as 5 etapas em ordem — colhe decisões (`.schematize/overdev/DECISOES.md`,
  ADR-lite) → ancora no grafo (`/eng-index`, §39) → PLAN pesado (`.schematize/overdev/PLAN.md`: escopo
  entra/NÃO-entra, itens verificáveis com nó+prova+deps+risco, ordem, paralelismo, riscos, DoD) →
  CHECKLIST exaustivo (`.schematize/overdev/CHECKLIST.md`, 3 classes, rastreável) → briefing
  (`<project>_archive/overdev/<data>-CONTEXTO.md`).
- **Gate da Fase 0:** decisões colhidas · grafo carregado (ou ausência + item de gerá-lo) · plano
  pesado · checklist derivado · briefing gravado → **passa o bastão**: `schematize overdev start
  "<objetivo>"` + `/eng-overdev`.

## Relação com as outras skills

- **schematize-engineering** — a base: esta skill é a **Fase 0 do overdev** (§0) rodando solta;
  consome índice/MAPA (§39), DoD (§35), archive (§28), orquestração; alimenta o `/eng-overdev`.
- **schematize-audit** — depois **cobra** que o fundado fechou (decisão→item feito? checklist
  sanado? on-hold respondido?); órfão vira saneamento.

## Gestão de contexto (sessões longas)

Ao se aproximar do teto de contexto: **PARE e** gere o handoff em `<project>_archive/context/`
(quais das 5 etapas fecharam + o que falta) **antes** de compactar (`/overdev-context-cc`).

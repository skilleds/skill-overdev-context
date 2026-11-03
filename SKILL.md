---
name: schematize-overdev-context
metadata:
  version: 0.6.0
description: >-
  Fase 0 do overdev: colhe decisões, ancora no grafo, escreve PLAN e deriva o CHECKLIST ([ ] máquina, [H ] humano, [~] on-hold). Use ao iniciar/retomar overdev. Não tickeia item.
---

# O montador de contexto do overdev (schematize-overdev-context)

Disciplina normativa, **agnóstica de linguagem**, que responde a uma pergunta só: **como um
overdev NASCE bem fundado?** A resposta não é "abre o checklist e sai tickando" — é **com a Fase
0 inteira montada antes do primeiro item**: as decisões já acordadas colhidas, o grafo do índice
ancorado, o plano pesado escrito e o checklist exaustivo derivado dele. Esta skill é o
**montador desse contexto**: ela produz o **briefing** que o laço de trabalho consome.

É a contraparte de **fundação** do overdev. O `/eng-overdev` (motor `schematize overdev start`)
roda o **laço** — tickeia item a item e não deixa parar até fechar. Esta skill **monta o
contexto** que aquele laço CONSOME. Onde a `schematize-engineering` descreve a Fase 0 dentro do
overdev (reference `overdev.md` §0), aqui ela vira **skill própria**, com comando dedicado, pra
rodar solta: montar o contexto uma vez, revisar, e só então soltar o laço.

Pular a fundação é a causa nº 1 de **plano raso, retrabalho e "reabrir o que já foi combinado"**.
Esta skill existe pra matar isso: **planejamento pesado antes de começar**, ancorado no código
de verdade (o grafo), rastreável (cada decisão vira item, cada item aponta a decisão).

**Versão:** skill `schematize-overdev-context` v0.6.0. Changelog em `CHANGELOG.md`.

## Precedência e herança (leia antes de divergir)

<!-- herdado:engineering/precedencia:dominio intro="Esta skill é o recorte **Fase 0 do overdev** da base: monta decisões, plano e checklist antes do laço (`schematize-engineering` → `references/overdev.md` §0), sem substituir a base." cmd="overdev-context" -->Esta skill é o recorte **Fase 0 do overdev** da base: monta decisões, plano e checklist antes do laço (`schematize-engineering` → `references/overdev.md` §0), sem substituir a base.

1. **Onde esta skill divergir da base, a BASE MANDA.** Aqui mora a especialização do domínio ou da
   ferramenta — o como, o padrão, o gate. Divergência de *piso* é defeito desta skill, não variante local.
2. **O que não está repetido aqui é HERDADO, não dispensado.** Esta skill herda os pisos da base e
   os comandos dela cobrem o **domínio**, não o piso geral. Valem integralmente, sem cópia local:
   - **§28 Archive** — `<projeto>/<projeto>_archive/` é **repositório git próprio, PRIVADO e
     obrigatório**, criticidade 0 (`schematize-archive`).
   - **§35 Definition of Done** e a lista de anti-padrões (citada por **título**, nunca por número).
   - **§39 Índice/MAPA** — enumeração exaustiva (uma entrada por unidade chamável, `M == N`) e grafo
     com arestas em ASCII (`A -> B`), nunca a seta unicode.
   - **IAM** (`schematize-engineering` → `references/iam.md`): identidade ≠ email, ≥2 fatores, ReBAC
     multi-tenant, argon2id-only para senha nova, sessão longa e logout irreversível.
   - **Efeito externo** nunca sai de não-produção (`schematize-engineering` →
     `references/efeitos-externos.md`).
   - **Orquestração** (`schematize-engineering` → `references/orquestracao.md` §9): o principal não
     desenvolve (é Claude Opus); executor mais barato que resolve — `haiku`/`sonnet` → Codex Terra → Cursor → `opus` só após falha; visual direto ao Codex; imagem nunca pelo Claude: detecta Codex/Gemini e pergunta ao usuário qual usar (Codex é a sugestão, não automática), nunca API paga.
3. **QA, ops, IAM e índice não têm comando próprio aqui:** vêm da base `/eng-*`. Para trabalho
   contínuo use `/eng-overdev`; para planejar `/eng-plan`; para varrer a base `/eng-scan`; para
   revisão geral `/eng-review` (e `/eng-ops`, `/eng-iam`, `/eng-index`). Os comandos
   `/overdev-context-*` cobrem o domínio desta skill; o piso geral é o da base.<!-- /herdado -->

## Comandos (Claude Code)

Digite `/overdev-context-help` pra ver todos. Em resumo:

| Comando | O que faz |
|---|---|
| `/overdev-context-help` | lista todos os comandos do schematize-overdev-context |
| `/overdev-context-build` | **monta a Fase 0**: varre a sessão/repo e colhe as DECISÕES acordadas (`.schematize/overdev/DECISOES.md`), ancora no GRAFO do índice, escreve o PLAN pesado (`.schematize/overdev/PLAN.md`), deriva o CHECKLIST exaustivo (`.schematize/overdev/CHECKLIST.md`) e entrega o DOCUMENTO DE CONTEXTO GERAL (briefing) — pronto pro `/eng-overdev` consumir |
| `/overdev-context-load` | carrega à força TODO o corpo normativo (contexto, decisões, plano/checklist, briefing) e passa a aplicá-lo |
| `/overdev-context-claude` | cria ou mescla o `CLAUDE.md` sempre-on de montagem de contexto na raiz do repo |
| `/overdev-context-cc` | context compact: gera handoff no archive e roda `/compact` |
| `/overdev-context-handoff` | gera o handoff (context.md + checklist.md) sem compactar |

Os comandos ficam em `assets/commands/` e são instalados em `.claude/commands/`.

## Como usar esta skill

1. **Monte o contexto** (`/overdev-context-build`, `references/contexto.md`): rode as **cinco
   etapas em ordem** — decisões → grafo → plano → checklist → briefing. É a Fase 0 inteira, num
   passo. Não entre no laço aqui: esta skill **funda**, não tickeia.
2. **Colha as decisões primeiro** (`references/decisoes.md`): varra a sessão/o repo e extraia o
   que **já foi acordado** (as fechadas, não as abandonadas) em formato ADR-lite. Isso **trava o
   que já foi combinado** e vira input do plano. Ambíguo/em aberto **não se inventa** — vira
   candidato a `- [~]` on-hold.
3. **Ancore no grafo** (`references/contexto.md` §2): o plano se prende ao **MAPA + adjacência**
   do índice (§39). Sem índice ainda? **gerá-lo é o 1º item** do checklist.
4. **Planeje pesado, derive o checklist** (`references/plano-checklist.md`): escopo entra/NÃO
   entra, decomposição em itens verificáveis **do tamanho de uma micro-task de Sonnet, com tag
   `[sonnet]`/`[opus: motivo]`**, ordem topológica, paralelismo, riscos, DoD. O
   checklist é a **projeção executável do plano**, exaustivo **por contagem**, nas 3 classes
   (`- [ ]`/`- [H ]`/`- [~]`).
5. **Entregue o briefing** (`references/briefing.md`): um documento coeso que amarra objetivo +
   decisões + grafo + plano + checklist + riscos, gravado no archive. É o que o overdev abre pra
   trabalhar e o que o humano lê pra acompanhar.
6. **Feche o gate com prova** (`scripts/check-contexto.sh`, instalado em
   `.claude/skills/schematize-overdev-context/scripts/`): confere por execução os artefatos
   (`DECISOES.md`, `PLAN.md`, `CHECKLIST.md`, `OBJETIVO.md`, `<data>-CONTEXTO.md`), a contagem por
   classe, decisão→item e o grafo. Exit 0 = Fase 0 fechada; sem isso o gate é opinião.
7. **Não trabalhe de memória** — o método, o formato das decisões, a anatomia do plano/checklist
   e do briefing estão nos references. Aplique os pisos abaixo independentemente do reference
   carregado.

Mapa de references — leia o que casa com a tarefa:

| Tarefa | Reference |
|---|---|
| O método completo: as 5 etapas (decisões → grafo → plano → checklist → briefing), o gate da Fase 0, o que esta skill NÃO faz, quando rodar | `references/contexto.md` |
| Etapa 1 a fundo: varrer a sessão/repo, o que conta como decisão **acordada** (vs abandonada/ambígua), o formato ADR-lite, o mapa decisão→item, onde gravar | `references/decisoes.md` |
| Etapas 3+4: anatomia do PLAN pesado (escopo, decomposição verificável, ordem/paralelismo, riscos, DoD) e a derivação do CHECKLIST exaustivo por contagem na convenção de 3 classes | `references/plano-checklist.md` |
| Etapa 5: anatomia do DOCUMENTO DE CONTEXTO GERAL (briefing), o que amarra, onde grava, como o `/eng-overdev` e o painel consomem | `references/briefing.md` |

## Pisos inegociáveis (vetam o atalho)

Independente do reference, estes limites nunca são cruzados:

1. **Fundação ANTES do laço — sempre, sem exceção.** Nenhum item é tickado antes de as cinco
   etapas fecharem. Começar a codar sem decisões colhidas, grafo ancorado, plano pesado e
   checklist derivado é exatamente a macaquice que esta skill existe pra matar. Esta skill
   **funda**; quem tickeia é o `/eng-overdev`.
2. **Decisão só entra se foi ACORDADA — e com origem rastreável.** Só vão pro `DECISOES.md` as
   decisões **fechadas** no contexto (decisão · motivo · alternativa descartada · **origem** onde
   no contexto/repo). O que ficou ambíguo/em aberto **não se inventa**: vira candidato a `- [~]`
   on-hold, não vira decisão de fachada.
3. **O plano se ancora no GRAFO real, não no ar.** Cada item aponta o(s) **nó(s)** que toca
   (função/serviço/`arquivo:linha`) e as **arestas** afetadas. Sem índice (§39) ainda? **gerá-lo
   é o 1º item** do checklist — não se planeja cego.
4. **Checklist exaustivo POR CONTAGEM, cada item com como provar.** Um item por linha, pequeno,
   com o jeito de provar (teste/comando/gate). Checklist magro = "terminei" precoce embutido na
   fundação. Se o usuário já tem um checklist, ele é **incorporado inteiro** — nunca resumido/aparado.
5. **Convenção de 3 classes no checklist.** `- [ ]`/`- [x]` = item de **máquina** (fecha com
   prova automática: teste/gate). `- [H ]`/`- [H x]` = item que exige **verificação humana**
   (revisão de olho, decisão de produto, aceite). `- [~]` = **on-hold/parkeado** (pergunta
   pendente; **conta como ABERTO**, igual ao hook). Cada classe fecha do seu jeito; máquina não
   auto-fecha item humano. Sobrou `- [H ]`/`- [~]` sem caminho → `.schematize/overdev/BLOCKED`.
6. **Rastreabilidade decisão→item→nó.** Cada decisão de (1) vira **≥1 item** do checklist; cada
   item aponta a **decisão que o justifica** e o **nó do grafo** que toca. Decisão sem item é
   decisão esquecida; item sem decisão/nó é item solto. O briefing exibe esse mapa.
7. **Saída durável no archive + control-plane.** Os artefatos vivem em `.schematize/overdev/`
   (`DECISOES.md`, `PLAN.md`, `CHECKLIST.md` — control-plane que o hook lê, trate como `.git`,
   **gitignore**) **e** espelhados em `<projeto>_archive/overdev/` (registro humano durável §28).
   O briefing vai pro archive. Sem archive, a fundação não aconteceu. O layout `.overdev/` é o
   **legado** aceito por compat: o motor (`schematize overdev start`) lê `.schematize/overdev`
   com fallback ao `.overdev` antigo e **auto-migra** no start; escreva sempre em `.schematize/`.
8. **Esta skill MONTA, não CONSOME.** Ela não entra no laço, não abre pool de pergunta
   bloqueante, não declara "pronto". Fechada a Fase 0, o `/eng-overdev` (ou `schematize overdev
   start`) assume o laço com o contexto já montado.

9. <!-- herdado:engineering/orquestracao:bullet -->**Orquestrador não desenvolve; subagent barato executa** (`schematize-engineering` → `references/orquestracao.md` §9). O principal só planeja/decompõe/despacha/supervisiona/revisa; ação onerosa vira micro-tasks; principal = Claude Opus; executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código, até 2 rodadas de correção pelo mesmo subagent) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo no checkpoint) → `park`; **visual direto ao Codex; imagem nunca pelo Claude (pergunta ao usuário: Codex sugerido, ou Gemini), API de imagem paga PROIBIDA**; papéis configuráveis em `agentes.toml` (aba "Agentes" do overdev). No `overdev`, cada item do checklist é executado pelo papel adequado e revisado pelo principal (diff + gate) antes do `- [x]`. **Sem frota ociosa:** agent idle com pendência executável volta ao trabalho; pendência que depende de outro agent → mata e enfileira com gatilho de dependência; terminou → mata (§9.6).<!-- /herdado -->
   A Fase 0 aplica isto assim: decompõe PLAN/CHECKLIST em itens de **uma micro-task de Sonnet**, cada um com tag `[sonnet]` (default) ou `[opus: <motivo>]` (só após escalada registrada); "decidir arquitetura" não é item — o desenho é do orquestrador; o briefing declara a escada.

10. Herda os pisos 22–29 da `schematize-engineering` (git como trava de conclusão, deploy só do git, ops é o gate da IA, sem agents inúteis, relatório 30 min/handoff 6 h, CI remoto só antes do hml, microserviço autônomo, build em dev/hml + higiene). Na Fase 0 isso vira o **bloco-piso** do checklist (push + `HEAD == origin`, relatório 30 min/handoff 6 h + `custos/`, matriz de acesso, passkey, gatilho de CI sem PR, 7 testes de resiliência) e a Fase 0 só fecha **commitada e empurrada** no archive (`check-contexto.sh`).

## Relação com as outras skills

- **schematize-engineering** — a **BASE**. Esta skill extrai a **Fase 0 do overdev** (reference
  `overdev.md` §0) pra rodar solta. Ela produz o que o **`/eng-overdev`** e o motor **`schematize
  overdev start`** consomem: `DECISOES.md`, `PLAN.md`, `CHECKLIST.md` e o briefing. Consome, por
  sua vez, o **índice/MAPA (§39)** (`/eng-index`), a **DoD (§35)**, o **archive (§28)** e a
  **orquestração** (fan-out ≥3 unidades independentes via `/eng-orchestrate`). O fluxo completo:
  **`/overdev-context-build` (funda)** → **`/eng-overdev` (laço, tickeia com prova)** → fim
  legítimo (checklist fechado + gate).
- **schematize-audit** — a **contraparte de histórico**. A auditoria depois COBRA que o que foi
  fundado aqui **fechou**: cada decisão virou item feito?, o checklist derivado do plano foi
  sanado?, on-hold parkeado foi respondido? Órfão que a audit acha vira saneamento (candidato a
  novo `/eng-overdev`). Montar bem o contexto aqui é o que dá à auditoria um rastro auditável.
- **schematize-web / go / rust / elixir / c# / zig / ruby / node** — esta skill é agnóstica: ela
  monta o contexto de um overdev **de qualquer stack**; a **prova** de cada item roda no gate
  daquela linguagem (`/<slug>-review`, testes, lint), referenciada no plano e no `gate.sh`.

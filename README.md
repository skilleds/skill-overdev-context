# schematize-overdev-context

> **O montador de CONTEXTO GERAL de um overdev** da casa — a **Fase 0 / fundação**, extraída da
> `schematize-engineering` para rodar **solta e agnóstica de linguagem**. É a skill que **MONTA**
> o briefing que o `/eng-overdev` (e o motor `schematize overdev start`) **CONSOME** antes de
> entrar no laço. Ela **funda**, nunca tickeia: colhe as decisões acordadas, ancora no grafo,
> planeja pesado e deriva o checklist exaustivo — depois entrega o laço já com o contexto pronto.

Pacote de **skill normativa para [Claude Code](https://claude.com/claude-code)**.
Parte do catálogo **schematize skills**. Pareia com a `schematize-engineering` (a base: overdev §0,
índice/MAPA §39, DoD §35, archive §28, orquestração), alimenta o `/eng-overdev` +
`schematize overdev start` e é cobrada depois pela `schematize-audit`.

## Instalar

### Pelo app schematize (recomendado)

```bash
schematize install overdev-context      # requer o CLI schematize instalado
```

### Última versão (a partir de um clone)

```bash
git clone https://github.com/schematizeme/skill-overdev-context.git
cd skill-overdev-context && ./install.sh            # instala no projeto atual
# ./install.sh /caminho/do/projeto                    # ou aponte para outro projeto
```

Ou baixe o `.zip` da última release e descompacte em `.claude/skills/`:

```bash
curl -L -o skill-overdev-context.zip \
  https://github.com/schematizeme/skill-overdev-context/releases/latest/download/skill-overdev-context.zip
unzip skill-overdev-context.zip -d .claude/skills/
```

## O que tem dentro

- **SKILL.md** — o contrato: 9 pisos inegociáveis (fundação antes do laço; decisão só entra se
  acordada e com origem rastreável; plano ancorado no grafo real do índice; checklist exaustivo
  por contagem; convenção de 3 classes `- [ ]`/`- [H ]`/`- [~]`; rastreabilidade decisão→item→nó;
  saída durável no archive + control-plane `.schematize/overdev/`; esta skill MONTA, não CONSOME) + mapa de
  references.
- **references/** — `contexto` (o método completo: as 5 etapas decisões → grafo → plano →
  checklist → briefing, o gate da Fase 0, o que a skill NÃO faz), `decisoes` (varrer a sessão/repo,
  o que conta como decisão acordada, o formato ADR-lite, o mapa decisão→item), `plano-checklist`
  (anatomia do PLAN pesado e a derivação do CHECKLIST exaustivo na convenção de 3 classes),
  `briefing` (anatomia do DOCUMENTO DE CONTEXTO GERAL e como o `/eng-overdev` + o painel consomem).
- **assets/commands/** — `/overdev-context-help`, `/overdev-context-build`,
  `/overdev-context-load`, `/overdev-context-claude`, `/overdev-context-cc`,
  `/overdev-context-handoff`.
- **assets/CLAUDE.md** — regra sempre-on da montagem de contexto.

## Comandos (Claude Code)

Digite `/overdev-context-help` pra ver todos. Em resumo:

| Comando | O que faz |
|---|---|
| `/overdev-context-help` | lista todos os comandos do schematize-overdev-context |
| `/overdev-context-build` | **monta a Fase 0**: colhe as DECISÕES acordadas (`.schematize/overdev/DECISOES.md`), ancora no GRAFO do índice, escreve o PLAN pesado (`.schematize/overdev/PLAN.md`), deriva o CHECKLIST exaustivo (`.schematize/overdev/CHECKLIST.md`) e entrega o DOCUMENTO DE CONTEXTO GERAL (briefing) — pronto pro `/eng-overdev` consumir |
| `/overdev-context-load` | carrega à força TODO o corpo normativo (contexto, decisões, plano/checklist, briefing) e passa a aplicá-lo |
| `/overdev-context-claude` | cria ou mescla o `CLAUDE.md` sempre-on de montagem de contexto na raiz do repo |
| `/overdev-context-cc` | context compact: gera handoff no archive e roda `/compact` |
| `/overdev-context-handoff` | gera o handoff (context.md + checklist.md) sem compactar |

## Regra de ouro

**Um overdev nasce bem fundado — nunca "abre o checklist e sai tickando".** A Fase 0 inteira vem
antes do primeiro item: decisões acordadas colhidas, grafo do índice ancorado, plano pesado
escrito e checklist exaustivo derivado dele. Esta skill **monta esse contexto** e para aí; quem
tickeia é o `/eng-overdev`. Pular a fundação é a causa nº 1 de plano raso, retrabalho e "reabrir
o que já foi combinado".

## Relação com as outras skills

- **schematize-engineering** — a **base**: esta skill extrai a **Fase 0 do overdev** (reference
  `overdev.md` §0) pra rodar solta e produz o que o `/eng-overdev` + `schematize overdev start`
  consomem (`DECISOES.md`, `PLAN.md`, `CHECKLIST.md` e o briefing); consome o índice/MAPA (§39),
  a DoD (§35), o archive (§28) e a orquestração. Fluxo: **`/overdev-context-build` (funda)** →
  **`/eng-overdev` (laço, tickeia com prova)** → fim legítimo.
- **schematize-audit** — a **contraparte de histórico**: depois COBRA que o que foi fundado aqui
  fechou (cada decisão virou item feito?, o checklist foi sanado?, on-hold parkeado foi
  respondido?). Montar bem o contexto aqui é o que dá à auditoria um rastro auditável.
- **schematize-web / go / rust / elixir / csharp / zig / ruby / node** — esta skill é agnóstica:
  monta o contexto de um overdev de **qualquer stack**; a **prova** de cada item roda no gate
  daquela linguagem (`/<slug>-review`, testes, lint), referenciada no plano.

Co-autoria / patrocínio: Lucassa — https://lucassa.me

MIT.

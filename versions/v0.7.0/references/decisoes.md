# Etapa 1 — colher as DECISÕES já acordadas (o que trava o que já foi combinado)

> A pior forma de retrabalho é **re-debater o que já foi decidido**. O overdev que começa sem
> colher as decisões acordadas reabre discussão fechada, contradiz o que o usuário combinou três
> mensagens atrás, e gasta o run em thrashing. Esta etapa **congela o acordado** num artefato
> rastreável, antes de o plano nascer.

O produto é **`.schematize/overdev/DECISOES.md`** (+ espelho no `<projeto>_archive/overdev/`), em formato
**ADR-lite**. É **input do plano** (§3 de `contexto.md`) e a **fonte da verdade** do "isto já
está decidido, não se re-abre".

## 1. Onde varrer (as fontes da decisão)

- **A sessão/conversa atual, inteira** — de cima a baixo. É a fonte primária: o que o usuário
  pediu, aceitou, vetou, corrigiu, priorizou. Inclui correções ("na verdade, faz X e não Y") —
  a **última palavra** sobre um ponto é a que vale.
- **O repo** — decisões já materializadas: ADRs existentes (`accepted`), `DECISOES.md` de runs
  anteriores, CLAUDE.md/README com convenções, o próprio código (uma escolha já implementada é
  uma decisão de fato).
- **O archive** (`<projeto>_archive/`) — decisões de handoffs, planos e overdevs passados que
  seguem valendo.

## 2. O que conta como decisão ACORDADA (e o que NÃO conta)

| Situação | Entra no DECISOES.md? |
|---|---|
| Usuário pediu/aceitou explicitamente | **Sim** — decisão acordada |
| Foi proposto e o usuário confirmou/não objetou após ver | **Sim** — acordo tácito, registre a origem |
| Você assumiu um **default razoável** e o documentou (custo de errar reversível) | **Sim** — registre como decisão **com default assumido** e sua origem |
| Foi discutido e **abandonado** (trocado por outra coisa) | **Não** — é a *alternativa descartada* de outra decisão, não uma decisão |
| Ficou **ambíguo / em aberto / "depois a gente vê"** | **Não** — vira candidato a `- [~]` on-hold (§4), **não se inventa** decisão |
| É uma preferência sua que o usuário nunca viu | **Não** — se for irreversível, parkeia; se reversível, assume default e documenta |

Regra de ouro: **decisão de fachada é pior que decisão ausente.** Registrar como "acordado" algo
que ninguém acordou trava o plano numa direção errada com aparência de legitimidade. Na dúvida
entre "acordado" e "ambíguo", é **ambíguo** → on-hold.

## 3. O formato ADR-lite

Uma entrada por decisão. Campos:

```
### D<n>. <título curto da decisão>
- **Decisão:** <o que foi decidido, em uma frase acionável>
- **Motivo:** <por que — a razão que a sustenta>
- **Alternativa descartada:** <o que se considerou e NÃO se escolheu, e por quê>
- **Origem:** <onde no contexto/repo — "sessão: msg do usuário sobre X" | "arquivo:linha" | "ADR-007">
- **Reversibilidade:** <reversível | irreversível | caro-de-reverter>
- **Deriva itens:** <D<n> → C<k>, C<m>  (preenchido ao derivar o checklist, §4)>
```

- **Numere** (`D1..Dn`) — o número é a âncora que o checklist referencia (rastreabilidade).
- **Origem é obrigatória** — decisão sem origem não é auditável; a `schematize-audit` cobra isso.
- **Default assumido** entra explícito ("assumi X por ser reversível; se errado, é 1 item de
  ajuste") — honestidade sobre o que foi decidido vs assumido.

## 4. O mapa decisão→item (fecha na etapa 4)

Cada decisão **acordada** tem que virar **≥1 item** do checklist — senão é decisão esquecida.
Quando o checklist for derivado (§4 de `contexto.md`), volte aqui e preencha o campo **Deriva
itens** de cada `D<n>` com os `C<k>` que a realizam. O briefing (§5) exibe esse mapa como tabela
`Decisão → Item(ns) → Nó(s) do grafo`. Auditar o overdev depois é, em boa parte, checar que esse
mapa fechou.

## 5. As ambíguas → on-hold, não decisão

Toda vez que a varredura topar um ponto **não fechado** (o usuário não definiu, ou há tensão não
resolvida), **não invente**. Registre-o como candidato a `- [~]` on-hold:

- anote a **pergunta** (o que precisa ser decidido) — vai pra `./PERGUNTAS-OVERDEV.txt` quando o
  overdev começar;
- marque o **item** correspondente como `- [~]` no checklist (conta como aberto; sem caminho → `BLOCKED`);
- se der pra **seguir com um default reversível**, faça isso e **promova a decisão** (§2, linha
  do default) — parkeia só o que for de fato irreversível/ambíguo demais.

Isso mantém a fundação honesta: o que está decidido está travado; o que não está, está
**visivelmente pendente**, não escondido atrás de uma decisão inventada.

## Piso da etapa

1. Só entra decisão **acordada**, com **origem rastreável**.
2. **Ambíguo não vira decisão** — vira on-hold.
3. Cada decisão **numerada** e destinada a **≥1 item** do checklist.
4. Grava em `.schematize/overdev/DECISOES.md` **e** espelha no archive (§28).

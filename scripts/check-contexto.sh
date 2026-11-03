#!/usr/bin/env bash
# check-contexto.sh — gate VERIFICÁVEL da Fase 0 (schematize-overdev-context, contexto.md §6).
#
# O quê: prova por execução que a fundação do overdev está fechada, em vez de "parece pronta".
# Checa: (1) os artefatos existem e não estão vazios — control-plane `DECISOES.md`, `PLAN.md`,
# `CHECKLIST.md`, e no archive `overdev/OBJETIVO.md` (espelho) + `overdev/<AAAA-MM-DD>-CONTEXTO.md`
# (briefing); (2) a contagem por classe do checklist (`- [ ]` máquina, `- [H ]` humano, `- [~]`
# on-hold, mais os fechados) e que há ao menos 1 item; (3) toda decisão `### D<n>` do DECISOES.md
# é citada por >=1 item do checklist (decisão sem item = decisão esquecida); (4) todo item de
# máquina aberto leva a tag de executor `[sonnet]`/`[opus: motivo]`; (5) o grafo está ancorado:
# existe `<archive>/index/` OU o checklist tem um item de gerar o índice.
# Endurecido (revisão G8): o gate NÃO aprova stub. Além do acima, exige: PLAN.md com as seções Entra, NÃO entra,
# Riscos e DoD; todo item de máquina aberto com `prova:`; todo item (exceto on-hold) rastreável a uma decisão
# `[D<n>]` ou ao bloco-piso `[piso]`; `[~]` ↔ PERGUNTAS-OVERDEV.txt; espelho do archive idêntico ao control-plane;
# o BLOCO-PISO (itens-padrão dos pisos 20-29: push + HEAD==origin, relatório 30 min/handoff 6 h e, se couber,
# matriz de acesso, passkey, gatilho de CI, resiliência) e, piso 22, a Fase 0 COMMITADA E EMPURRADA no archive.
# Uso:   check-contexto.sh [--sem-git] [dir-control-plane] [dir-archive]
#        --sem-git: pula o piso 22 (archive commitado/empurrado) — só para ensaio; Fase 0 real não usa.
#        defaults: .schematize/overdev (ou .overdev legado) e o único `*_archive` do diretório atual.
# Saída: 0 = Fase 0 fechada; 1 = ao menos uma falha (cada uma impressa); 2 = uso/ambiente.
set -euo pipefail

SEMGIT=0; POS=()
for a in "$@"; do case "$a" in --sem-git) SEMGIT=1 ;; *) POS+=("$a") ;; esac; done
SD="${POS[0]:-}"
if [ -z "$SD" ]; then
  if [ -d .schematize/overdev ]; then SD=.schematize/overdev
  elif [ -d .overdev ]; then SD=.overdev
  else echo "check-contexto: sem control-plane (.schematize/overdev)" >&2; exit 2; fi
fi
AR="${POS[1]:-}"
if [ -z "$AR" ]; then
  mapfile -t cands < <(find . -maxdepth 2 -type d -name '*_archive' -not -path '*/.git/*' | sort)
  [ "${#cands[@]}" -eq 1 ] || { echo "check-contexto: informe o archive (achei ${#cands[@]} candidatos)" >&2; exit 2; }
  AR="${cands[0]}"
fi
[ -d "$SD" ] || { echo "check-contexto: '$SD' não existe" >&2; exit 2; }
[ -d "$AR" ] || { echo "check-contexto: '$AR' não existe" >&2; exit 2; }

falhas=0
falha() { echo "  FALHA: $1"; falhas=$((falhas+1)); }
tem() { [ -s "$1" ] || { falha "artefato ausente ou vazio: $1"; return 1; }; }
conta() { local n; n="$(grep -cE "$1" "$2" 2>/dev/null || true)"; echo "${n:-0}"; }

echo "== 1. artefatos =="
tem "$SD/DECISOES.md" || true
tem "$SD/PLAN.md" || true
tem "$SD/CHECKLIST.md" || true
tem "$AR/overdev/OBJETIVO.md" || true
briefings=("$AR"/overdev/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-CONTEXTO.md)
if [ ! -s "${briefings[0]}" ]; then falha "briefing ausente: $AR/overdev/<AAAA-MM-DD>-CONTEXTO.md"; fi

if [ -s "$SD/PLAN.md" ]; then
  for sec in 'Entra' 'N[AÃ]O entra' 'Riscos?' 'DoD'; do
    grep -qiE "^#{1,4}[[:space:]]+.*\b$sec\b" "$SD/PLAN.md" || falha "PLAN.md sem a secao '${sec//\\/}' (escopo entra/NAO entra, riscos, DoD)"
  done
fi
# espelho no archive (quando existe) tem de ser IDENTICO ao control-plane
for f in CHECKLIST.md DECISOES.md PLAN.md; do
  [ -f "$AR/overdev/$f" ] && [ -f "$SD/$f" ] && ! cmp -s "$AR/overdev/$f" "$SD/$f" && falha "espelho $AR/overdev/$f diverge de $SD/$f"
done

CL="$SD/CHECKLIST.md"
if [ -s "$CL" ]; then
  echo "== 2. contagem por classe =="
  maq_a="$(conta '^[[:space:]]*- \[ \]' "$CL")"; maq_f="$(conta '^[[:space:]]*- \[x\]' "$CL")"
  hum_a="$(conta '^[[:space:]]*- \[H \]' "$CL")"; hum_f="$(conta '^[[:space:]]*- \[H x\]' "$CL")"
  hold="$(conta '^[[:space:]]*- \[~\]' "$CL")"
  total=$((maq_a+maq_f+hum_a+hum_f+hold))
  echo "  maquina: $maq_a abertos / $maq_f feitos · humano: $hum_a abertos / $hum_f feitos · on-hold: $hold · total: $total"
  [ "$total" -ge 1 ] || falha "checklist sem nenhum item"

  echo "== 3. decisao -> item =="
  if [ -s "$SD/DECISOES.md" ]; then
    mapfile -t decs < <(grep -oE '^#{2,4}[[:space:]]+D[0-9]+\b' "$SD/DECISOES.md" | grep -oE 'D[0-9]+' || true)
    [ "${#decs[@]}" -ge 1 ] || falha "DECISOES.md sem nenhuma decisao '### D<n>.'"
    for d in "${decs[@]}"; do
      grep -E '^[[:space:]]*- \[' "$CL" | grep -qE "\\b$d\\b" || falha "decisao $d sem nenhum item no checklist"
    done
    echo "  decisoes: ${#decs[@]}"
  fi

  echo "== 4. tag de executor nos itens de maquina abertos =="
  sem_tag="$(grep -E '^[[:space:]]*- \[ \]' "$CL" | grep -vE '\[(sonnet|opus:[^]]+)\]' | wc -l || true)"
  [ "${sem_tag:-0}" -eq 0 ] || falha "$sem_tag item(ns) de maquina abertos sem [sonnet]/[opus: motivo]"

  echo "== 4b. prova e rastreabilidade (item -> decisao) =="
  sem_prova="$(grep -E '^[[:space:]]*- \[ \]' "$CL" | grep -viE 'prova' | wc -l || true)"
  [ "${sem_prova:-0}" -eq 0 ] || falha "$sem_prova item(ns) de maquina abertos sem 'prova:' (como provar) — item que ninguem sabe fechar"
  sem_dec="$(grep -E '^[[:space:]]*- \[(x| |H |H x)\]' "$CL" | grep -vE '\[D[0-9]+|\[piso\]|\bD[0-9]+\b' | wc -l || true)"
  [ "${sem_dec:-0}" -eq 0 ] || falha "$sem_dec item(ns) sem decisao de origem ([D<n>]) nem [piso] — item solto"

  echo "== 4c. on-hold <-> PERGUNTAS-OVERDEV.txt =="
  if [ "$hold" -gt 0 ]; then
    perg=""
    for c in ./PERGUNTAS-OVERDEV.txt "$SD/PERGUNTAS-OVERDEV.txt" "$SD/../PERGUNTAS-OVERDEV.txt" "$AR/overdev/PERGUNTAS-OVERDEV.txt"; do [ -s "$c" ] && { perg="$c"; break; }; done
    [ -n "$perg" ] || falha "$hold item(ns) [~] on-hold e nenhum PERGUNTAS-OVERDEV.txt com a pergunta"
  fi

  echo "== 4d. bloco-piso (pisos 20-29 no checklist) =="
  tudo="$CL"; [ -s "$SD/PLAN.md" ] && tudo="$CL $SD/PLAN.md"
  item() { grep -E '^[[:space:]]*- \[' "$CL" | grep -qiE "$1"; }
  item 'push.*(origin)|HEAD *== *origin|HEAD==origin' || falha "bloco-piso: falta item de push + HEAD == origin (piso 22)"
  item 'relat[oó]rio|handoff' || falha "bloco-piso: falta item de relatorio 30 min / handoff 6 h no archive (piso 26)"
  if grep -qiE '\b(rotas?|endpoints?|routes?)\b' $tudo; then item 'matriz|check-route-authz' || falha "bloco-piso: ha rota/endpoint e falta item de matriz de acesso M == N (piso 20)"; fi
  if grep -qiE '\b(auth|login|iam|passkey|webauthn)\b' $tudo; then item 'passkey|webauthn' || falha "bloco-piso: ha auth/login e falta item de passkey na fase 0 (piso 21)"; fi
  if grep -qiE '\b(ci|workflow|github actions)\b' $tudo; then item 'workflow_dispatch|hml|check-ci-triggers|sem pull_request' || falha "bloco-piso: ha CI e falta item do gatilho dispatch + tags hml-*/v* (piso 27)"; fi
  if grep -qiE 'microservi[cç]o' $tudo; then item 'resili|check-resilience|fila durável|fila duravel' || falha "bloco-piso: ha microservico e falta item de resiliencia / 7 testes (piso 28)"; fi

  echo "== 5. grafo ancorado =="
  if [ ! -d "$AR/index" ] && ! grep -qiE '^[[:space:]]*- \[.{0,2}\].*(índice|indice|/eng-index|MAPA)' "$CL"; then
    falha "sem $AR/index/ e sem item de gerar o indice no checklist"
  fi
fi

if [ "$SEMGIT" -eq 0 ]; then
  echo "== 6. Fase 0 commitada e empurrada (piso 22) =="
  if ! git -C "$AR" rev-parse --git-dir >/dev/null 2>&1; then falha "$AR nao e repo git — o archive e repo PROPRIO e privado (piso 22)"
  elif [ -z "$(git -C "$AR" remote -v 2>/dev/null)" ]; then falha "archive sem remote — crie o repo privado e dê push (piso 22)"
  else
    [ -z "$(git -C "$AR" status --porcelain 2>/dev/null)" ] || falha "archive com alteracoes nao commitadas — commit + push da Fase 0 (piso 22)"
    up="$(git -C "$AR" rev-parse -q --verify '@{u}' 2>/dev/null || true)"
    if [ -z "$up" ]; then falha "archive sem upstream — git push -u origin <branch>"
    elif [ "$(git -C "$AR" rev-parse HEAD)" != "$up" ]; then falha "HEAD do archive != origin — push da Fase 0 pendente (piso 22)"; fi
  fi
fi

if [ "$falhas" -gt 0 ]; then echo "FASE 0 ABERTA: $falhas falha(s)"; exit 1; fi
echo "FASE 0 FECHADA"

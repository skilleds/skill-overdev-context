#!/usr/bin/env bash
# Vermelho primeiro do gate da Fase 0. Cada caso planta UMA lacuna que o gate tem de pegar.
# EXCEÇÃO DECLARADA de strict mode (`schematize-shell` -> `references/piso.md` secao 1):
# harness de teste roda sem `-e` de propósito — ele precisa continuar depois de um caso
# vermelho para reportar TODOS, em vez de parar no primeiro.
set -u
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$AQUI/check-contexto.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
ok=0; fail=0
checa() { local nome="$1" esp="$2" agulha="$3" dir="$4"
  local saida; saida="$(cd "$dir" && bash "$G" .schematize/overdev p_archive 2>&1)"; local rc=$?
  if [ "$rc" != "$esp" ]; then echo "  ✖ $nome: exit $rc, esperado $esp"; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  if [ -n "$agulha" ] && ! grep -qF -- "$agulha" <<<"$saida"; then echo "  ✖ $nome: exit certo, saida sem \"$agulha\""; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  echo "  ✔ $nome"; ok=$((ok+1)); }

export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
# bloco-piso padrao (itens dos pisos 22 e 26) — todo checklist de Fase 0 real os traz
PISO=$'- [ ] [sonnet] push de cada repo e HEAD == origin (prova: check-git.sh --conclusao) [piso]\n- [ ] [sonnet] relatorio 30 min e handoff 6 h no archive (prova: check-ritmo.sh) [piso]\n'
publica() { git -C "$1" add -A && git -C "$1" commit -q -m i && git -C "$1" push -q -u origin HEAD 2>/dev/null; }
novo() { local d="$TMP/$1"; rm -rf "$d"; mkdir -p "$d/.schematize/overdev" "$d/p_archive/overdev" "$d/p_archive/index"
  printf '### D1. Usar X\n- **Decisao:** X\n### D2. Usar Y\n- **Decisao:** Y\n' > "$d/.schematize/overdev/DECISOES.md"
  printf '# PLAN\n## Entra\nescopo\n## NAO entra\nfora\n## Riscos\nnenhum\n## DoD\ntestes\n' > "$d/.schematize/overdev/PLAN.md"
  { printf -- '- [ ] [sonnet] implementar X (prova: make t) [D1]\n- [ ] [sonnet] implementar Y (prova: make t) [D2]\n- [H ] aceite visual [D2]\n- [~] pergunta aberta\n- [x] [sonnet] feito antigo [D1]\n'; printf '%s' "$PISO"; } > "$d/.schematize/overdev/CHECKLIST.md"
  printf 'qual o prazo?\n' > "$d/PERGUNTAS-OVERDEV.txt"
  printf '# objetivo\n' > "$d/p_archive/overdev/OBJETIVO.md"
  printf '# briefing\n' > "$d/p_archive/overdev/2026-10-14-CONTEXTO.md"
  git -C "$d/p_archive" init -q -b main; git init -q --bare "$TMP/rem-$1.git"; git -C "$d/p_archive" remote add origin "$TMP/rem-$1.git"
  echo x > "$d/p_archive/index/MAPA.md"; publica "$d/p_archive"
  echo "$d"; }
chk() { printf -- '%s' "$1" > "$d/.schematize/overdev/CHECKLIST.md"; }

echo "== verde de partida =="
d="$(novo ok)"; checa verde 0 "FASE 0 FECHADA" "$d"
checa contagem-por-classe 0 "maquina: 4 abertos / 1 feitos · humano: 1 abertos / 0 feitos · on-hold: 1 · total: 7" "$d"

echo "== vermelhos plantados =="
d="$(novo sem-decisoes)"; rm "$d/.schematize/overdev/DECISOES.md"; checa sem-DECISOES 1 "DECISOES.md" "$d"
d="$(novo sem-plan)"; rm "$d/.schematize/overdev/PLAN.md"; checa sem-PLAN 1 "PLAN.md" "$d"
d="$(novo sem-checklist)"; rm "$d/.schematize/overdev/CHECKLIST.md"; checa sem-CHECKLIST 1 "CHECKLIST.md" "$d"
d="$(novo sem-objetivo)"; rm "$d/p_archive/overdev/OBJETIVO.md"; checa sem-espelho-OBJETIVO 1 "OBJETIVO.md" "$d"
d="$(novo sem-briefing)"; rm "$d/p_archive/overdev/2026-10-14-CONTEXTO.md"; checa sem-briefing 1 "briefing ausente" "$d"
d="$(novo checklist-vazio)"; : > "$d/.schematize/overdev/CHECKLIST.md"; checa checklist-vazio 1 "CHECKLIST.md" "$d"
d="$(novo checklist-sem-item)"; printf 'so texto, nenhum item\n' > "$d/.schematize/overdev/CHECKLIST.md"; checa checklist-sem-item 1 "sem nenhum item" "$d"
d="$(novo decisao-orfa)"; printf '### D3. Z\n' >> "$d/.schematize/overdev/DECISOES.md"; checa decisao-sem-item 1 "decisao D3 sem nenhum item" "$d"
d="$(novo decisoes-sem-D)"; printf 'texto livre sem decisoes numeradas\n' > "$d/.schematize/overdev/DECISOES.md"; checa DECISOES-sem-Dn 1 "sem nenhuma decisao" "$d"
d="$(novo sem-tag)"; chk "$(printf -- '- [ ] implementar sem tag (prova: x) [D1]\n- [ ] [sonnet] y (prova: x) [D2]\n%s' "$PISO")"; checa item-sem-tag 1 "sem [sonnet]" "$d"
d="$(novo sem-grafo)"; rm -r "$d/p_archive/index"; git -C "$d/p_archive" add -A; git -C "$d/p_archive" commit -qm x; git -C "$d/p_archive" push -q; checa sem-grafo-e-sem-item 1 "indice" "$d"
d="$(novo grafo-via-item)"; rm -r "$d/p_archive/index"; git -C "$d/p_archive" add -A; git -C "$d/p_archive" commit -qm x; git -C "$d/p_archive" push -q; chk "$(printf -- '- [ ] [sonnet] gerar o indice /eng-index (prova: MAPA.md existe) [D1]\n- [ ] [sonnet] y (prova: x) [D2]\n%s' "$PISO")"; checa grafo-ausente-mas-com-item-de-gerar 0 "FASE 0 FECHADA" "$d"

echo "== G8: o gate nao aprova stub =="
d="$(novo plan-sem-riscos)"; printf '# PLAN\n## Entra\nx\n## NAO entra\ny\n## DoD\nz\n' > "$d/.schematize/overdev/PLAN.md"; checa plan-sem-secao-riscos 1 "sem a secao 'Riscos" "$d"
d="$(novo plan-stub)"; printf '# PLAN\nescopo\n' > "$d/.schematize/overdev/PLAN.md"; checa plan-stub-de-uma-linha 1 "PLAN.md sem a secao" "$d"
d="$(novo item-sem-prova)"; chk "$(printf -- '- [ ] [sonnet] x [D1]\n- [ ] [sonnet] y (prova: x) [D2]\n%s' "$PISO")"; checa item-sem-prova 1 "sem 'prova:'" "$d"
d="$(novo item-sem-decisao)"; chk "$(printf -- '- [ ] [sonnet] solto (prova: x)\n- [ ] [sonnet] a (prova: x) [D1]\n- [ ] [sonnet] b (prova: x) [D2]\n%s' "$PISO")"; checa item-sem-decisao 1 "sem decisao de origem" "$d"
d="$(novo onhold-sem-pergunta)"; rm "$d/PERGUNTAS-OVERDEV.txt"; checa onhold-sem-PERGUNTAS 1 "PERGUNTAS-OVERDEV.txt" "$d"
d="$(novo espelho-diverge)"; cp "$d/.schematize/overdev/CHECKLIST.md" "$d/p_archive/overdev/CHECKLIST.md"; echo "- [x] extra [D1]" >> "$d/p_archive/overdev/CHECKLIST.md"; publica "$d/p_archive"; checa espelho-diverge 1 "diverge de" "$d"
d="$(novo sem-item-push)"; chk "$(printf -- '- [ ] [sonnet] a (prova: x) [D1]\n- [ ] [sonnet] b (prova: x) [D2]\n- [ ] [sonnet] relatorio 30 min (prova: x) [piso]\n')"; checa bloco-piso-sem-push 1 "push + HEAD == origin" "$d"
d="$(novo sem-item-relatorio)"; chk "$(printf -- '- [ ] [sonnet] a (prova: x) [D1]\n- [ ] [sonnet] b (prova: x) [D2]\n- [ ] [sonnet] push e HEAD == origin (prova: x) [piso]\n')"; checa bloco-piso-sem-relatorio 1 "relatorio 30 min" "$d"
d="$(novo rota-sem-matriz)"; printf -- '- criar a rota POST /pedidos\n' >> "$d/.schematize/overdev/PLAN.md"; checa rota-sem-matriz 1 "matriz de acesso" "$d"
d="$(novo auth-sem-passkey)"; printf -- '- login via IAM\n' >> "$d/.schematize/overdev/PLAN.md"; checa auth-sem-passkey 1 "passkey" "$d"
d="$(novo ci-sem-gatilho)"; printf -- '- montar o CI\n' >> "$d/.schematize/overdev/PLAN.md"; checa ci-sem-gatilho 1 "gatilho dispatch" "$d"
d="$(novo microservico-sem-resiliencia)"; printf -- '- novo microservico ledger\n' >> "$d/.schematize/overdev/PLAN.md"; checa microservico-sem-resiliencia 1 "resiliencia" "$d"
d="$(novo rota-com-matriz)"; printf -- '- criar a rota POST /pedidos\n' >> "$d/.schematize/overdev/PLAN.md"; chk "$(cat "$d/.schematize/overdev/CHECKLIST.md"; printf -- '- [ ] [sonnet] matriz de acesso da rota (prova: check-route-authz.sh) [D1]\n')"; checa rota-com-matriz-passa 0 "FASE 0 FECHADA" "$d"

echo "== piso 22: Fase 0 commitada e empurrada =="
d="$(novo archive-sujo)"; echo y > "$d/p_archive/overdev/NOTAS.md"; checa archive-nao-commitado 1 "nao commitadas" "$d"
d="$(novo archive-nao-empurrado)"; echo y > "$d/p_archive/overdev/NOTAS.md"; git -C "$d/p_archive" add -A; git -C "$d/p_archive" commit -qm n; checa archive-HEAD-diverge 1 "HEAD do archive != origin" "$d"
d="$(novo archive-sem-remote)"; git -C "$d/p_archive" remote remove origin; checa archive-sem-remote 1 "sem remote" "$d"
d="$(novo archive-sem-git)"; rm -rf "$d/p_archive/.git"; checa archive-nao-e-repo 1 "nao e repo git" "$d"
d="$(novo sem-git-flag)"; rm -rf "$d/p_archive/.git"; saida="$(cd "$d" && bash "$G" --sem-git .schematize/overdev p_archive 2>&1)"; rc=$?; if [ "$rc" = 0 ]; then echo "  ✔ --sem-git pula o piso 22"; ok=$((ok+1)); else echo "  ✖ --sem-git: $saida"; fail=$((fail+1)); fi

echo; echo "$ok ok, $fail falha(s)"; [ "$fail" -eq 0 ]

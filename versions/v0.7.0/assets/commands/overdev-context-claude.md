---
description: schematize-overdev-context — cria ou mescla o CLAUDE.md sempre-on de montagem de contexto do overdev na raiz do repo (não sobrescreve blocos de outras skills)
---

Instale/atualize a regra **sempre-on** de montagem de contexto do overdev na raiz do repositório.

1. Pegue `assets/CLAUDE.md` da skill `schematize-overdev-context` (projeto ou `~/.claude/skills/...`).
2. Se **não existe** `CLAUDE.md` na raiz: crie com esse conteúdo.
3. Se **já existe** (de outra skill — engineering/go/rust/web/audit/...): **mescle** — adicione a
   seção de Montagem de Contexto do Overdev **sem sobrescrever** os blocos das outras skills. Em
   repo multi-skill, cada CLAUDE convive; o piso desta é aditivo.
4. Se houver customização local, salve `./CLAUDE.md.bak` e reaplique por cima.
5. Confirme a versão aplicada e destaque o **piso**: fundação antes do laço; decisão só se
   acordada (ambíguo → on-hold); checklist exaustivo na convenção de 3 classes; esta skill **monta**,
   o `/eng-overdev` **consome**.

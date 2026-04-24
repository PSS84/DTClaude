# hello-world (GitHub Pages)

Referência rápida dos comandos usados para enviar esta pasta (e o restante do repo) para o GitHub.

## Primeira vez (repositório novo na pasta do projeto)

No PowerShell:

```powershell
cd "g:\Meu Drive\PESSOAL\PLANEJAMENTO\2026RE\DT_Claude"

git init
git add hello-world/index.html
git commit -m "Add hello-world page for GitHub Pages"
git branch -M main

git remote add origin https://github.com/SEU_USUARIO/NOME_DO_REPO.git
git push -u origin main
```

Substitua `SEU_USUARIO` e `NOME_DO_REPO` pela URL real copiada em **Code → HTTPS** no GitHub.

Se `origin` já existir com URL errada:

```powershell
git remote set-url origin https://github.com/SEU_USUARIO/NOME_DO_REPO.git
git push -u origin main
```

## Atualizações depois (só enviar mudanças)

```powershell
cd "g:\Meu Drive\PESSOAL\PLANEJAMENTO\2026RE\DT_Claude"

git add hello-world/
git status
git commit -m "Atualiza hello-world"
git push
```

Para versionar o projeto inteiro, troque `git add hello-world/` por `git add .` (cuidado: inclui tudo no diretório).

## Ver o site no navegador

Com Pages na raiz do branch `main`, a página desta pasta fica em:

`https://SEU_USUARIO.github.io/NOME_DO_REPO/hello-world/`

Ajuste usuário e nome do repositório. Em **Settings → Pages** o GitHub mostra a URL publicada.

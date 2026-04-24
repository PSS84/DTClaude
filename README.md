# DT_Claude

Repositorio principal para organizar projetos de estudo, operacao e automacao com foco em day trade, produtividade e suporte a operacoes profissionais.

## Visao geral

Este workspace centraliza subpastas com objetivos diferentes e integra fluxo de desenvolvimento com:

- `Git` + `GitHub` para versionamento
- `Python` para servicos e automacoes
- `Render` para deploy web
- `Cursor` + `Claude` para aceleracao de desenvolvimento

## Estrutura principal

- `cockpit-b3/`: projeto futuro para operacoes de day trade.
- `dados_diario/`: base para noticias macroeconomicas e impactos em mini indice, mini dolar e bitcoin.
- `dados/`: dados de referencia versionados (ex.: planilhas). No momento contem `TABELA 2026.xlsx`, usada como fonte da verdade para precos na pagina do Guarani.
- `ferramentas/`: armazenamento de ferramentas e instaladores.
- `guarani/`: projeto de apoio comercial; inclui leitura da planilha e templates HTML.
  - `guarani/Script/`: scripts Python do modulo (ex.: `precos_2026.py`).
  - `guarani/templates/`: templates Jinja/HTML (ex.: `precos_2026.html`).
- `hello-world/`: area de testes.
- `Scripts/`: scripts utilitarios para operacoes no GitHub (inclui variantes para arquivo e diretorio).
- `manual/`: documentacao detalhada do projeto.

## Aplicacao web (Flask) na raiz

Arquivos principais:

- `app.py`: aplicacao Flask publicada no Render.
- `requirements.txt`: dependencias (`flask`, `gunicorn`, `pandas`, `openpyxl`).

Rotas uteis:

- `/`: pagina inicial com link para a tabela de precos.
- `/guarani/precos`: tabela de precos gerada a partir da aba `2026` de `dados/TABELA 2026.xlsx`.

Regra importante: a planilha em `dados/` e a fonte da verdade; o HTML e montado a partir dos dados lidos no servidor.

## Deploy no Render

Configuracao tipica do Web Service:

- `Language`: `Python 3`
- `Build Command`: `pip install -r requirements.txt`
- `Start Command`: `gunicorn app:app`
- `Root Directory`: vazio (raiz do repositorio)

Apos `git push`, o Render pode redeployar automaticamente; se o layout nao atualizar, use deploy manual do ultimo commit e atualize o navegador com recarregamento forcado.

## Documentacao detalhada

Para historico, troubleshooting e detalhes operacionais:

- `manual/README.md`

## Roadmap macro

- Estruturar o `cockpit-b3` para operacao e analise.
- Evoluir `dados_diario` com coleta e organizacao diaria de noticias.
- Expandir o modulo `guarani` (filtros, exportacao, autenticacao se necessario).
- Ampliar scripts de automacao em `Scripts/`.

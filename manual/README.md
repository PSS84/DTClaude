# Manual do Projeto DT_Claude

## Objetivo deste manual

Este documento registra o que ja foi montado no projeto local `DT_Claude`, qual e o papel de cada pasta, como funciona o servico web no Render e como os dados de precos do Guarani sao obtidos a partir da planilha (fonte da verdade).

## Visao geral do ambiente

- Plataforma de codigo local: `Cursor`
- Assistente de apoio: `Claude`
- Controle de versao: `Git` + `GitHub` (remoto: `PSS84/DTClaude`)
- Deploy web: `Render`
- Stack do servico publicado: `Python 3` + `Flask` + `Gunicorn`
- Dados tabulares: `pandas` + `openpyxl` (leitura de `.xlsx`)

## Estrutura local atual do projeto

Raiz local: `DT_Claude`

- `cockpit-b3/`
  - Base do projeto futuro sobre operacoes em day trade.
- `dados_diario/`
  - Espaco para receber e organizar noticias macroeconomicas do dia e analisar impactos em operacoes de mini indice, mini dolar e bitcoin.
- `dados/`
  - Dados de referencia versionados. Contem `TABELA 2026.xlsx`; a aba `2026` alimenta a pagina publica de precos do Guarani.
- `ferramentas/`
  - Armazenamento de ferramentas e instaladores uteis do ecossistema.
- `guarani/`
  - Modulo Guarani: precos e materiais de apoio comercial.
  - `guarani/Script/precos_2026.py`: le a planilha, interpreta secoes (PRODUTOS, ADICIONAIS, etc.) e prepara valores para exibicao.
  - `guarani/templates/precos_2026.html`: layout da pagina (secoes expansiveis, busca no navegador, tabelas responsivas).
- `hello-world/`
  - Area de testes e validacoes rapidas.
- `Scripts/`
  - Scripts utilitarios para automacoes de GitHub e manutencao de arquivos.
  - Inclui `subir_arquivo_github.ps1` e `subir_diretorio_github.ps1` (este ultimo para enviar um diretorio inteiro em um commit).
- `app.py`
  - Aplicacao Flask servida no Render. Define rotas e aponta templates para `guarani/templates/`.
- `requirements.txt`
  - Dependencias: `flask`, `gunicorn`, `pandas`, `openpyxl`.
- `manual/`
  - Documentacao do projeto (este arquivo).

## O que foi construido ate aqui

1. Organizacao da estrutura local com pastas por objetivo.
2. Configuracao do remoto no GitHub (`PSS84/DTClaude`).
3. Primeiro deploy no Render com servico Python (`gunicorn app:app`).
4. Correcao de build quando faltava `requirements.txt` no repositorio (erro `No such file or directory: 'requirements.txt'`).
5. Modulo Guarani com pagina de precos:
   - dados lidos de `dados/TABELA 2026.xlsx` (aba `2026`);
   - rota publica `/guarani/precos`;
   - evolucao de layout mantendo a planilha como unica fonte de dados.
6. Scripts PowerShell em `Scripts/` para facilitar `git add`, commit e push de arquivos ou pastas.

## Como funciona a pagina de precos (fonte da verdade)

1. O usuario acessa `/guarani/precos` no servico hospedado no Render.
2. `app.py` chama `carregar_precos_2026(...)` em `guarani/Script/precos_2026.py`.
3. O script abre `dados/TABELA 2026.xlsx`, le a aba `2026` e identifica blocos pela linha de cabecalho de cada secao.
4. O resultado e renderizado com `guarani/templates/precos_2026.html`.

Observacao: valores exibidos devem sempre refletir a planilha versionada em `dados/`. Evite duplicar precos em codigo Python estático; qualquer ajuste de negocio deve ser feito na planilha e commitado.

## Configuracao usada no Render

Campos usuais do Web Service:

- `Language`: `Python 3`
- `Build Command`: `pip install -r requirements.txt`
- `Start Command`: `gunicorn app:app`
- `Root Directory`: vazio (raiz do repositorio)

Observacoes importantes:

- O bloco **Environment Variables** nao substitui **Build Command** e **Start Command**.
- O erro `Could not open requirements file: requirements.txt` indica que o arquivo nao esta no commit/deploy ou o `Root Directory` esta apontando para outra pasta.
- Para `gunicorn app:app`, o arquivo deve ser `app.py` e a instancia Flask deve se chamar `app`.

## Fluxo operacional atual (GitHub -> Render)

1. Editar arquivos localmente (codigo, planilha em `dados/`, templates em `guarani/templates/`, etc.).
2. `git add`, `git commit`, `git push` para `main` (ou usar scripts em `Scripts/`).
3. No Render, aguardar deploy automatico ou acionar deploy manual do ultimo commit.
4. Conferir logs se o build falhar (dependencias, arquivo ausente, erro de leitura da planilha).
5. Validar no navegador; se o layout parecer antigo, usar recarregamento forcado ou aba anonima (cache).

## Scripts de apoio ja existentes

Na pasta `Scripts/`:

- `subir_arquivo_github.ps1`: adiciona um arquivo ou pasta (caminho relativo), commita e envia.
- `subir_diretorio_github.ps1`: fluxo semelhante, validando que o caminho e diretorio.
- `atualizar_arquivo_github.ps1`, `delete_arquivo_github.ps1`: manutencao de conteudo no repositorio.

## Proximos passos sugeridos

- Definir convencoes de branch/commit quando varios subprojetos evoluirem ao mesmo tempo.
- Evoluir `cockpit-b3` (day trade) e `dados_diario` (macro e leitura diaria).
- Para `guarani`: filtros adicionais, export CSV/PDF, ou camada de autenticacao se a pagina ficar com dados sensiveis.
- Endpoint simples de saude (`/health`) para monitorar deploy.

---
Documento para manter clareza de escopo, estrutura e operacao do ambiente de desenvolvimento e deploy.

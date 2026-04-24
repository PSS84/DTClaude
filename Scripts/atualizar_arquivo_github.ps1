<#
.SYNOPSIS
  Envia a versao local de um arquivo para o GitHub (git add, commit, push).
.DESCRIPTION
  Voce informa usuario, repositorio, diretorio no repo (relativo a raiz) e nome do arquivo.
  O caminho local segue a mesma arvore (ex: hello-world + index.html -> hello-world/index.html).
  Equivale a atualizar o arquivo na web para o conteudo que esta na sua maquina.
#>

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    $cur = $PSScriptRoot
    while ($cur) {
        $gitDir = Join-Path $cur ".git"
        if (Test-Path $gitDir) {
            return (Resolve-Path $cur).Path
        }
        $parent = Split-Path $cur -Parent
        if (-not $parent -or $parent -eq $cur) { break }
        $cur = $parent
    }
    $loc = (Get-Location).Path
    $cur = $loc
    while ($cur) {
        if (Test-Path (Join-Path $cur ".git")) { return $cur }
        $parent = Split-Path $cur -Parent
        if (-not $parent -or $parent -eq $cur) { break }
        $cur = $parent
    }
    return $null
}

$repoRoot = Get-RepoRoot
if (-not $repoRoot) {
    Write-Host "Nao encontrei a raiz do Git (.git). Use este script a partir da pasta Scripts/ na raiz do repo." -ForegroundColor Red
    exit 1
}

Set-Location $repoRoot
Write-Host "Repositorio: $repoRoot" -ForegroundColor DarkGray

$ghUser = Read-Host "Seu usuario no GitHub (ex: joaosilva)"
if ([string]::IsNullOrWhiteSpace($ghUser)) {
    Write-Host "Usuario obrigatorio." -ForegroundColor Red
    exit 1
}

$ghRepo = Read-Host "Nome do repositorio no GitHub (ex: DTClaude)"
if ([string]::IsNullOrWhiteSpace($ghRepo)) {
    Write-Host "Nome do repositorio obrigatorio." -ForegroundColor Red
    exit 1
}

$dirPart = Read-Host "Diretorio no repo, relativo a raiz (ex: hello-world). Vazio = arquivo na raiz"
if ($null -eq $dirPart) { $dirPart = "" }
$dirPart = $dirPart.Trim().TrimStart("/").Replace("\", "/").TrimEnd("/")

$fileName = Read-Host "Nome do arquivo a atualizar (ex: index.html)"
if ([string]::IsNullOrWhiteSpace($fileName)) {
    Write-Host "Nome do arquivo obrigatorio." -ForegroundColor Red
    exit 1
}
$fileName = $fileName.Trim()

if ($dirPart) {
    $relativePath = "$dirPart/$fileName".Replace("//", "/")
} else {
    $relativePath = $fileName
}

$fullPath = Join-Path $repoRoot ($relativePath -replace "/", [IO.Path]::DirectorySeparatorChar)
if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
    Write-Host "Arquivo local nao encontrado (esperado um arquivo, nao pasta): $fullPath" -ForegroundColor Red
    exit 1
}

$defaultMsg = "Atualiza $relativePath"
$commitMsg = Read-Host "Mensagem do commit [Enter = '$defaultMsg']"
if ([string]::IsNullOrWhiteSpace($commitMsg)) { $commitMsg = $defaultMsg }

$originUrl = "https://github.com/$ghUser/$ghRepo.git"
$remotes = git remote 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Falha ao ler remotes. Git instalado?" -ForegroundColor Red
    exit 1
}

if ($remotes -contains "origin") {
    git remote set-url origin $originUrl
} else {
    git remote add origin $originUrl
}

Write-Host "origin -> $originUrl" -ForegroundColor DarkCyan
Write-Host "Atualizando no Git: $relativePath" -ForegroundColor Cyan

git add -- $relativePath
if ($LASTEXITCODE -ne 0) {
    Write-Host "git add falhou." -ForegroundColor Red
    exit 1
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Nada novo para enviar (conteudo igual ao ultimo commit ou arquivo ignorado)." -ForegroundColor Yellow
} else {
    git commit -m "$commitMsg"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "git commit falhou." -ForegroundColor Red
        exit 1
    }
}

$branch = git branch --show-current
if ([string]::IsNullOrWhiteSpace($branch)) {
    Write-Host "Nao foi possivel detectar a branch atual." -ForegroundColor Red
    exit 1
}

git push -u origin $branch
if ($LASTEXITCODE -ne 0) {
    Write-Host "git push falhou. Verifique autenticacao e se o remoto esta correto." -ForegroundColor Red
    exit 1
}

Write-Host "Concluido. Arquivo publicado no GitHub (branch $branch)." -ForegroundColor Green

<#
.SYNOPSIS
  Remove arquivo ou pasta inteira do Git e envia para o GitHub.
.DESCRIPTION
  So remove caminhos ja rastreados (git rm). Nao cria pastas nem arquivos no GitHub:
  pastas existem apenas quando ha arquivos; ao remover todos, a pasta some do repo.
  Pergunta usuario, repositorio, diretorio e nome do arquivo (ou pasta inteira se nome vazio).
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

function Test-HasTrackedFiles {
    param([string]$PathNoSlash, [switch]$AsDirectory)
    $a = @(git ls-files -- "$PathNoSlash" 2>$null)
    if ($a.Count -gt 0) { return $true }
    if ($AsDirectory) {
        $b = @(git ls-files -- "$PathNoSlash/" 2>$null)
        if ($b.Count -gt 0) { return $true }
    }
    return $false
}

$repoRoot = Get-RepoRoot
if (-not $repoRoot) {
    Write-Host "Nao encontrei a raiz do Git (.git). Execute na pasta do repositorio ou em Scripts/ na raiz." -ForegroundColor Red
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

$dirPart = Read-Host "Caminho da pasta no repo, relativo a raiz (ex: hello-world ou hello-world/scripts)"
if ($null -eq $dirPart) { $dirPart = "" }
$dirPart = $dirPart.Trim().TrimStart("/").Replace("\", "/").TrimEnd("/")

$fileName = Read-Host "Nome do arquivo dentro dessa pasta (ex: README.md). Vazio = remover a pasta inteira (todo conteudo)"
if ($null -eq $fileName) { $fileName = "" }
$fileName = $fileName.Trim()

$removeTree = [string]::IsNullOrWhiteSpace($fileName)
if ($removeTree) {
    if ([string]::IsNullOrWhiteSpace($dirPart)) {
        Write-Host "Para remover uma pasta inteira, informe o caminho dela no campo anterior." -ForegroundColor Red
        exit 1
    }
    $relativePath = $dirPart
} else {
    if ($dirPart) {
        $relativePath = "$dirPart/$fileName".Replace("//", "/")
    } else {
        $relativePath = $fileName
    }
}

if (-not (Test-HasTrackedFiles -PathNoSlash $relativePath -AsDirectory:$removeTree)) {
    Write-Host "Nenhum arquivo rastreado pelo Git em: $relativePath" -ForegroundColor Red
    Write-Host "Confira o caminho (relativo a raiz do repo)." -ForegroundColor Yellow
    exit 1
}

$defaultMsg = "Remove $relativePath"
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
if ($removeTree) {
    Write-Host "Removendo pasta (recursivo): $relativePath" -ForegroundColor Yellow
    git rm -r -f -- "$relativePath"
} else {
    Write-Host "Removendo arquivo: $relativePath" -ForegroundColor Yellow
    git rm -f -- "$relativePath"
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "git rm falhou." -ForegroundColor Red
    exit 1
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Nada staged apos git rm (inesperado)." -ForegroundColor Red
    exit 1
}

git commit -m "$commitMsg"
if ($LASTEXITCODE -ne 0) {
    Write-Host "git commit falhou." -ForegroundColor Red
    exit 1
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

Write-Host "Removido do GitHub (branch $branch). Nada foi criado, apenas deletado do historico visivel no proximo commit." -ForegroundColor Green

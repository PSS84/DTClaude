<#
.SYNOPSIS
  Adiciona um diretorio, faz commit e envia para o GitHub.
.DESCRIPTION
  Baseado no script subir_arquivo_github.ps1, mas validando explicitamente
  que o caminho informado e um diretorio.
#>

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    $here = $PSScriptRoot
    $candidate = Resolve-Path (Join-Path $here "..")
    if (Test-Path (Join-Path $candidate ".git")) {
        return $candidate.Path
    }

    $d = Get-Location
    $cur = $d.Path
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
    Write-Host "Nao encontrei a raiz do Git (.git)." -ForegroundColor Red
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

$relativeDir = Read-Host "Diretorio a enviar, relativo a raiz do repo (ex: guarani)"
if ([string]::IsNullOrWhiteSpace($relativeDir)) {
    Write-Host "Diretorio obrigatorio." -ForegroundColor Red
    exit 1
}

$relativeDir = $relativeDir.Trim().TrimStart("/").Replace("\", "/")
$fullPath = Join-Path $repoRoot $relativeDir
if (-not (Test-Path $fullPath)) {
    Write-Host "Nao existe: $fullPath" -ForegroundColor Red
    exit 1
}

$item = Get-Item $fullPath
if (-not $item.PSIsContainer) {
    Write-Host "O caminho informado nao e um diretorio: $relativeDir" -ForegroundColor Red
    exit 1
}

$defaultMsg = "Adiciona diretorio $relativeDir"
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

git add -- $relativeDir
if ($LASTEXITCODE -ne 0) {
    Write-Host "git add falhou." -ForegroundColor Red
    exit 1
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Nada novo para commitar no diretorio (ja igual ao ultimo commit ou vazio)." -ForegroundColor Yellow
    exit 0
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
    Write-Host "git push falhou. Verifique autenticacao e remoto." -ForegroundColor Red
    exit 1
}

Write-Host "Concluido. Diretorio enviado: $relativeDir | Branch: $branch" -ForegroundColor Green

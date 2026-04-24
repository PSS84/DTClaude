<#
.SYNOPSIS
  Remove um arquivo rastreado pelo Git, faz commit e envia para o GitHub.
.DESCRIPTION
  Pergunta usuario, repositorio, diretorio (relativo a raiz do repo) e nome do arquivo.
  Monta o caminho, executa git rm, commit e push.
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
    Write-Host "Nao encontrei a raiz do Git (.git). Abra o terminal na pasta do repositorio ou mantenha este script em hello-world/scripts." -ForegroundColor Red
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

$dirPart = Read-Host "Diretorio no repo, relativo a raiz (ex: hello-world). Vazio = arquivo na raiz do Git"
$fileName = Read-Host "Nome do arquivo a remover (ex: README.md)"
if ([string]::IsNullOrWhiteSpace($fileName)) {
    Write-Host "Nome do arquivo obrigatorio." -ForegroundColor Red
    exit 1
}

$fileName = $fileName.Trim()
if ($null -eq $dirPart) { $dirPart = "" }
$dirPart = $dirPart.Trim().TrimStart("/").Replace("\", "/")

if ($dirPart) {
    $relativePath = "$dirPart/$fileName".Replace("//", "/")
} else {
    $relativePath = $fileName
}

$tracked = git ls-files -- "$relativePath" 2>$null
if (-not $tracked) {
    Write-Host "Nenhum arquivo rastreado pelo Git em: $relativePath" -ForegroundColor Red
    Write-Host "Confira diretorio e nome (caminho relativo a raiz do repo)." -ForegroundColor Yellow
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
Write-Host "Removendo: $relativePath" -ForegroundColor Yellow

git rm -f -- "$relativePath"
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

Write-Host "Arquivo removido do GitHub (branch $branch)." -ForegroundColor Green

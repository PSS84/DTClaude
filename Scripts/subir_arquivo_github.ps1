<#
.SYNOPSIS
  Adiciona um caminho (pasta ou arquivo), faz commit e envia para o GitHub.
.DESCRIPTION
  Pergunta usuário GitHub, nome do repositório e o caminho local (relativo à raiz do repo).
  Ajusta https://github.com/USUARIO/REPO.git em origin e executa git push.
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
    Write-Host "Nao encontrei a raiz do Git (.git). Execute o script de dentro do projeto ou coloque-o em Scripts/ na raiz do repo." -ForegroundColor Red
    exit 1
}

Set-Location $repoRoot
Write-Host "Repositorio: $repoRoot" -ForegroundColor DarkGray

$ghUser = Read-Host "Seu usuario no GitHub (ex: joaosilva)"
if ([string]::IsNullOrWhiteSpace($ghUser)) {
    Write-Host "Usuario obrigatorio." -ForegroundColor Red
    exit 1
}

$ghRepo = Read-Host "Nome do repositorio no GitHub (ex: DT_Claude)"
if ([string]::IsNullOrWhiteSpace($ghRepo)) {
    Write-Host "Nome do repositorio obrigatorio." -ForegroundColor Red
    exit 1
}

$relativePath = Read-Host "Caminho da pasta ou arquivo a enviar, relativo a raiz do repo (ex: hello-world ou hello-world/README.md)"
if ([string]::IsNullOrWhiteSpace($relativePath)) {
    Write-Host "Caminho obrigatorio." -ForegroundColor Red
    exit 1
}

$relativePath = $relativePath.Trim().TrimStart("/").Replace("\", "/")
$fullPath = Join-Path $repoRoot $relativePath
if (-not (Test-Path $fullPath)) {
    Write-Host "Nao existe: $fullPath" -ForegroundColor Red
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

git add -- $relativePath
if ($LASTEXITCODE -ne 0) {
    Write-Host "git add falhou." -ForegroundColor Red
    exit 1
}

# Usar apenas o que foi staged com "git add" (evita confundir com outros arquivos nao rastreados)
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Nada novo para commitar nesse caminho (ja igual ao ultimo commit ou ignorado)." -ForegroundColor Yellow
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

Write-Host "Concluido. Branch: $branch" -ForegroundColor Green

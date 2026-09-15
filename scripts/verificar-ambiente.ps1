$ErrorActionPreference = 'Stop'
$raizProjeto = Split-Path $PSScriptRoot -Parent
$faltando = @()
foreach ($ferramenta in @('node', 'npm', 'docker', 'flutter')) {
    $comando = Get-Command $ferramenta -ErrorAction SilentlyContinue
    if ($comando) {
        Write-Output "OK: $ferramenta ($($comando.Source))"
    } else {
        Write-Output "PENDENTE: $ferramenta indisponivel no PATH"
        $faltando += $ferramenta
    }
}
foreach ($relativo in @('backend/.env', 'backend/node_modules', 'codigo-fonte/.dart_tool/package_config.json')) {
    $existe = Test-Path (Join-Path $raizProjeto $relativo)
    Write-Output "$relativo : $existe"
}
if ($faltando.Count -gt 0) {
    Write-Output 'Consulte Documentacao-mvp/docs/testes-e-execucao-local.md para preparar o ambiente.'
    exit 1
}
& docker info --format '{{.ServerVersion}}'
if ($LASTEXITCODE -ne 0) { throw 'Docker instalado, mas o servico nao esta acessivel. Abra o Docker Desktop.' }
& flutter --version
if ($LASTEXITCODE -ne 0) { throw 'Flutter encontrado, mas nao foi possivel executa-lo.' }
Write-Output 'Ferramentas acessiveis. Ainda e necessario instalar dependencias, subir o banco e aplicar migracoes.'

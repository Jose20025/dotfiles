[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

if ($env:OS -ne 'Windows_NT') {
    throw 'Este script solo funciona en Windows.'
}

$sourceDirectory = $PSScriptRoot
$filesToInstall = @('config.yaml', 'styles.css')

foreach ($fileName in $filesToInstall) {
    $sourceFile = Join-Path -Path $sourceDirectory -ChildPath $fileName
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) {
        throw "No se encontro el archivo requerido: $sourceFile"
    }
}

if (Get-Process -Name 'yasb' -ErrorAction SilentlyContinue) {
    throw 'Cierra YASB antes de ejecutar este script y vuelve a intentarlo.'
}

$configDirectory = if ([string]::IsNullOrWhiteSpace($env:YASB_CONFIG_HOME)) {
    Join-Path -Path $HOME -ChildPath '.config\yasb'
} else {
    [Environment]::ExpandEnvironmentVariables($env:YASB_CONFIG_HOME)
}

$configDirectory = [IO.Path]::GetFullPath($configDirectory)
$normalizedSourceDirectory = [IO.Path]::GetFullPath($sourceDirectory).TrimEnd('\', '/')
$normalizedConfigDirectory = $configDirectory.TrimEnd('\', '/')

if ([string]::Equals(
        $normalizedSourceDirectory,
        $normalizedConfigDirectory,
        [StringComparison]::OrdinalIgnoreCase
    )) {
    throw 'La carpeta de configuracion no puede ser la carpeta yasb del repositorio.'
}

New-Item -ItemType Directory -Path $configDirectory -Force | Out-Null

$filesToBackup = @()
foreach ($fileName in $filesToInstall) {
    $destinationFile = Join-Path -Path $configDirectory -ChildPath $fileName
    if (Test-Path -LiteralPath $destinationFile) {
        if (-not (Test-Path -LiteralPath $destinationFile -PathType Leaf)) {
            throw "El destino existe y no es un archivo: $destinationFile"
        }

        $filesToBackup += $fileName
    }
}

if ($filesToBackup.Count -gt 0) {
    $backupDirectory = '{0}.backup-{1}' -f $configDirectory, (Get-Date -Format 'yyyyMMdd-HHmmss-fff')
    New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null

    foreach ($fileName in $filesToBackup) {
        $destinationFile = Join-Path -Path $configDirectory -ChildPath $fileName
        Copy-Item -LiteralPath $destinationFile -Destination $backupDirectory
    }

    Write-Host "Configuracion anterior respaldada en: $backupDirectory"
}

foreach ($fileName in $filesToInstall) {
    $sourceFile = Join-Path -Path $sourceDirectory -ChildPath $fileName
    Copy-Item -LiteralPath $sourceFile -Destination $configDirectory -Force
}

Write-Host "Configuracion YASB aplicada en: $configDirectory"
Write-Host 'Abre YASB para cargar los cambios.'

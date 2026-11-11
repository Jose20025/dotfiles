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

function Install-JetBrainsMonoPropo {
    Add-Type -AssemblyName System.Drawing
    $installedFonts = New-Object System.Drawing.Text.InstalledFontCollection
    try {
        if ($installedFonts.Families.Name -contains 'JetBrainsMono NFP' -or
            $installedFonts.Families.Name -contains 'JetBrainsMono Nerd Font Propo') {
            Write-Host 'JetBrainsMono Nerd Font Propo ya esta instalada.'
            return
        }
    } finally {
        $installedFonts.Dispose()
    }

    $temporaryDirectory = Join-Path ([IO.Path]::GetTempPath()) ('yasb-font-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $temporaryDirectory | Out-Null
    $previousSecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
    try {
        [Net.ServicePointManager]::SecurityProtocol = $previousSecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $archive = Join-Path $temporaryDirectory 'JetBrainsMono.zip'
        Write-Host 'Descargando JetBrainsMono desde el release oficial de Nerd Fonts...'
        Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip' -OutFile $archive -UseBasicParsing
        $extractedDirectory = Join-Path $temporaryDirectory 'fonts'
        Expand-Archive -LiteralPath $archive -DestinationPath $extractedDirectory
        $fontFiles = @(Get-ChildItem -LiteralPath $extractedDirectory -Recurse -File |
            Where-Object { $_.Name -match '^JetBrainsMonoNerdFontPropo-[A-Za-z]+\.ttf$' })
        if (-not ($fontFiles.Name -contains 'JetBrainsMonoNerdFontPropo-Regular.ttf')) {
            throw 'El archivo descargado no contiene la variante Propo esperada.'
        }

        if (-not ('YasbSetup.NativeFonts' -as [type])) {
            Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace YasbSetup {
    public static class NativeFonts {
        [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
        public static extern int AddFontResourceEx(string path, uint flags, IntPtr reserved);
        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern IntPtr SendMessageTimeout(IntPtr window, uint message,
            UIntPtr wParam, IntPtr lParam, uint flags, uint timeout, out UIntPtr result);
    }
}
'@
        }

        $fontDirectory = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
        $fontRegistry = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
        New-Item -ItemType Directory -Path $fontDirectory -Force | Out-Null
        if (-not (Test-Path -LiteralPath $fontRegistry)) {
            New-Item -Path $fontRegistry -Force | Out-Null
        }
        foreach ($font in $fontFiles) {
            $destination = Join-Path $fontDirectory $font.Name
            Copy-Item -LiteralPath $font.FullName -Destination $destination -Force
            if ([YasbSetup.NativeFonts]::AddFontResourceEx($destination, 0, [IntPtr]::Zero) -eq 0) {
                throw "Windows no pudo cargar la fuente: $destination"
            }
            New-ItemProperty -LiteralPath $fontRegistry -Name ($font.BaseName + ' (TrueType)') -Value $destination -PropertyType String -Force | Out-Null
        }
        $messageResult = [UIntPtr]::Zero
        [YasbSetup.NativeFonts]::SendMessageTimeout([IntPtr]0xffff, 0x001D,
            [UIntPtr]::Zero, [IntPtr]::Zero, 2, 5000, [ref]$messageResult) | Out-Null
        Write-Host 'JetBrainsMono Nerd Font Propo instalada para tu usuario.'
    } finally {
        [Net.ServicePointManager]::SecurityProtocol = $previousSecurityProtocol
        Remove-Item -LiteralPath $temporaryDirectory -Recurse -Force
    }
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

Install-JetBrainsMonoPropo

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

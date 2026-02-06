# --- Configuración Estética ---
$script:Root = $PSScriptRoot 
$omp_config = Join-Path $script:Root 'omp-themes\catppuccin_mocha.omp.json'

# Oh My Posh y Terminal-Icons
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config $omp_config | Invoke-Expression
}
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# --- Funciones de Navegación ---

# Crear y entrar a carpeta
function take { 
    param($p) 
    New-Item -ItemType Directory -Path $p -Force | Out-Null
    Set-Location $p 
}

# Accesos directos (Simplificados)
function gocode { Set-Location "D:\code" }
function gokais { Set-Location "D:\code\kais" }

# --- Aliases ---
Set-Alias -Name mkcd -Value take
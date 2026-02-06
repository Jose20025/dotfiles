# --- CONFIGURACIÓN DE PROGRAMADOR MALDITO ---

# Predicciones de historial (Tu nuevo mejor amigo)
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView

# --- Estética y Prompt ---
$script:Root = $PSScriptRoot 
$omp_config = Join-Path $script:Root 'omp-themes\catppuccin_mocha.omp.json'

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config $omp_config | Invoke-Expression
}
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

# Predicciones (PSReadLine)
if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle InlineView
}

# Zoxide (El navegador inteligente que tanto extrañas)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { zoxide init powershell | Out-String })
}

# --- Funciones de Navegación (La resurrección) ---

# Crear y entrar a carpeta (Tu preciado 'take')
function take { 
    param(
        [Parameter(Mandatory = $true)]
        [string]$p
    ) 
    if (!(Test-Path $p)) {
        New-Item -ItemType Directory -Path $p -Force | Out-Null
    }
    Set-Location $p 
}

# Accesos directos
function gocode { Set-Location "$HOME\Desktop\code" }
function gokais { Set-Location "$HOME\Desktop\code\kais" }

# --- Utilidades Extra para Windows ---

# Primero defines la lógica en una función
function Update-Profile {
    . $PROFILE
    Write-Host "Perfil recargado con éxito. Deja de romper cosas." -ForegroundColor Magenta
}


# Abrir el explorador de archivos en la ruta actual
function explore { Invoke-Item . }

# Ver puertos ocupados (Para cuando tu app de Node no cierra bien)
function ports { Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess }

# --- Aliases ---
Set-Alias -Name mkcd -Value take
Set-Alias -Name v -Value code
Set-Alias -Name reload -Value Update-Profile
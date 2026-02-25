# --- CONFIGURACION DE PROGRAMADOR MALDITO (Desktop) ---

Set-StrictMode -Version Latest


$script:Config = @{
    CodeRoot = 'D:\code'
    KaisRoot = 'D:\code\kais'
}

$script:ScriptRoot = if ($PSScriptRoot) {
    $PSScriptRoot
}
else {
    Split-Path -Parent $PROFILE
}

$script:OhMyPoshConfig = Join-Path $script:ScriptRoot 'omp-themes\catppuccin_mocha.omp.json'

function Import-OptionalModule {
    param([Parameter(Mandatory = $true)][string]$Name)

    if (Get-Module -ListAvailable -Name $Name) {
        try {
            Import-Module -Name $Name -ErrorAction Stop
        }
        catch {
            Write-Verbose "No se pudo cargar el modulo '$Name': $($_.Exception.Message)"
        }
    }
}

function Initialize-PsReadLine {
    Import-OptionalModule -Name 'PSReadLine'

    if (Get-Module -Name 'PSReadLine') {
        try {
            Set-PSReadLineOption -PredictionSource History
            Set-PSReadLineOption -PredictionViewStyle InlineView
        }
        catch {
            Write-Verbose "No se pudieron activar predicciones de PSReadLine: $($_.Exception.Message)"
        }
    }
}

function Initialize-Zoxide {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        try {
            Invoke-Expression (& { zoxide init powershell | Out-String })
        }
        catch {
            Write-Verbose "No se pudo inicializar zoxide: $($_.Exception.Message)"
        }
    }
}

function Initialize-OhMyPosh {
    if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        return
    }

    if (-not (Test-Path -LiteralPath $script:OhMyPoshConfig -PathType Leaf)) {
        Write-Warning "No se encontro el tema de oh-my-posh: $script:OhMyPoshConfig"
        return
    }

    try {
        oh-my-posh init pwsh --config $script:OhMyPoshConfig | Invoke-Expression
    }
    catch {
        Write-Warning "No se pudo inicializar oh-my-posh: $($_.Exception.Message)"
    }
}

function Set-SmartLocation {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        Write-Warning "Ruta no encontrada: $Path"
        return
    }

    if (Get-Command z -ErrorAction SilentlyContinue) {
        z $Path
    }
    else {
        Set-Location -LiteralPath $Path
    }
}

function take {
    param(
        [Parameter(Mandatory = $true)]
        [string]$p
    )

    if (Test-Path -LiteralPath $p) {
        if (-not (Test-Path -LiteralPath $p -PathType Container)) {
            Write-Error "Existe un archivo con ese nombre y no es carpeta: $p"
            return
        }
    }
    else {
        New-Item -ItemType Directory -Path $p -Force | Out-Null
    }

    Set-Location -LiteralPath $p
}

function gocode { Set-SmartLocation -Path $script:Config.CodeRoot }
function gokais { Set-SmartLocation -Path $script:Config.KaisRoot }
function explore { Invoke-Item . }

function Update-Profile {
    try {
        . $PROFILE
        Write-Host "Perfil recargado con exito. Deja de romper cosas." -ForegroundColor Magenta
    }
    catch {
        Write-Error "Error al recargar el perfil: $($_.Exception.Message)"
    }
}

function ports {
    Get-NetTCPConnection -State Listen |
    Sort-Object LocalPort |
    Select-Object LocalAddress, LocalPort, OwningProcess, @{
        Name       = 'ProcessName'
        Expression = {
            (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName
        }
    }
}

Set-Alias -Name mkcd -Value take -Option AllScope
Set-Alias -Name reload -Value Update-Profile -Option AllScope

Import-OptionalModule -Name 'Terminal-Icons'
Initialize-PsReadLine
Initialize-OhMyPosh
Initialize-Zoxide

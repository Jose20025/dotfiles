# Asegura que las rutas sean relativas a este archivo
$script:Root = $PSScriptRoot 

# amro.omp.json | pure.omp.json
$omp_config = Join-Path $script:Root 'omp-themes\catppuccin_mocha.omp.json'

# Initialize oh-my-posh
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

# Import Terminal-Icons module
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue

function GoDevFunc {
    Set-Location -Path "D:\dev"    
}

Set-Alias -Name godev -Value GoDevFunc

function GoKaisFunc {
    Set-Location -Path "D:/work/kais"    
}

Set-Alias -Name gokais -Value GoKaisFunc
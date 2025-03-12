# amro.omp.json | pure.omp.json
$omp_config = ".\omp-themes\amro.omp.json"

# Initialize oh-my-posh
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

# Import Terminal-Icons module
Import-Module -Name Terminal-Icons

function GoDevFunc {
    Set-Location -Path "D:\dev"    
}

Set-Alias -Name godev -Value GoDevFunc

function GoKaisFunc {
    Set-Location -Path "D:/dev/work/kais"    
}

Set-Alias -Name gokais -Value GoKaisFunc
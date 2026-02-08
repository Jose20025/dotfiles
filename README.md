# Configuracion de PowerShell personalizada

Este repositorio contiene mis dotfiles de PowerShell con una configuracion orientada a desarrollo, incluyendo `oh-my-posh`, `zoxide`, `PSReadLine` y utilidades de navegacion.

## Scripts disponibles

- `joseca_config.ps1`: perfil para desktop.
  - `CodeRoot`: `D:\code`
  - `KaisRoot`: `D:\code\kais`
- `joseca_config_laptop.ps1`: perfil para laptop.
  - `CodeRoot`: `Desktop\code`
  - `KaisRoot`: `Desktop\code\kais`

## Instalacion

1. Abre tu perfil de PowerShell (`$PROFILE`).
2. Agrega una linea con dot-source al script que quieras usar.

Ejemplo (desktop):

```powershell
. D:\dotfiles\joseca_config.ps1
```

Ejemplo (laptop):

```powershell
. D:\dotfiles\joseca_config_laptop.ps1
```

> Nota: el punto inicial (`.`) es obligatorio para cargar funciones y alias en la sesion actual.

## Que incluye

- Inicializacion de [oh-my-posh](https://ohmyposh.dev/) con el tema [`omp-themes/catppuccin_mocha.omp.json`](omp-themes/catppuccin_mocha.omp.json).
- Importacion opcional de [Terminal-Icons](https://github.com/devblackops/Terminal-Icons).
- Activacion de predicciones de `PSReadLine` (si el modulo esta instalado).
- Inicializacion de `zoxide` (si esta disponible en `PATH`).
- Funciones de productividad:
  - `gocode`: ir a `CodeRoot`.
  - `gokais`: ir a `KaisRoot`.
  - `take <ruta>`: crear carpeta (si no existe) y entrar.
  - `explore`: abrir la carpeta actual en el explorador.
  - `ports`: listar puertos en escucha con el proceso asociado.
  - `Update-Profile`: recargar el perfil actual.
- Alias:
  - `mkcd` -> `take`
  - `reload` -> `Update-Profile`

## Personalizacion

Si quieres cambiar el tema de `oh-my-posh`, edita en el script elegido la variable `$script:OhMyPoshConfig`.

Por ejemplo:

```powershell
$script:OhMyPoshConfig = Join-Path $script:ScriptRoot 'omp-themes\pure.omp.json'
```

Temas disponibles en este repo:

- `omp-themes/catppuccin_mocha.omp.json`
- `omp-themes/amro.omp.json`
- `omp-themes/pure.omp.json`

Luego recarga la sesion con `reload` o abre una terminal nueva.

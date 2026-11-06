# Configuracion de PowerShell personalizada

Este repositorio contiene mis dotfiles de PowerShell y la configuracion de OpenCode para desarrollo, incluyendo `oh-my-posh`, `zoxide`, `PSReadLine`, utilidades de navegacion y un agente con reglas de trabajo personalizadas.

## Estructura

- `joseca_config.ps1`: perfil de PowerShell para desktop.
- `joseca_config_laptop.ps1`: perfil de PowerShell para laptop.
- `omp-themes/`: temas personalizados de `oh-my-posh`.
- `opencode/`: configuracion, instrucciones y agentes de OpenCode.

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

## Configuracion de OpenCode

La configuracion se encuentra en [`opencode/opencode.jsonc`](opencode/opencode.jsonc) e incluye:

- `senior-twice` como agente predeterminado.
- [`opencode/AGENTS.md`](opencode/AGENTS.md) con reglas para usar Context7, Engram, CodeGraph y OpenSpec.
- [`opencode/agents/senior-twice.md`](opencode/agents/senior-twice.md) con el perfil, flujo de trabajo y estilo de comunicacion del agente.
- MCP local de `engram` para memoria persistente.
- MCP remoto de `context7` para consultar documentacion actualizada.
- MCP local de `codegraph` para explorar simbolos y relaciones del codigo.

Para usar esta configuracion, inicia OpenCode apuntando a este repositorio o copia la carpeta `opencode/` a la ubicacion de configuracion que utilice tu instalacion. El MCP de `engram` requiere que `engram.exe` este instalado en `C:\Users\<usuario>\go\bin\engram.exe`, y `codegraph` debe estar disponible en `PATH`.

Si utilizas Context7, configura su credencial en [`opencode/opencode.jsonc`](opencode/opencode.jsonc) usando el mecanismo de secretos de tu entorno; no guardes tokens reales en el repositorio.

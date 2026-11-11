# Dotfiles de Windows

Este repositorio contiene mis dotfiles de PowerShell, la configuracion de OpenCode para desarrollo y mi barra de YASB, incluyendo `oh-my-posh`, `zoxide`, `PSReadLine`, utilidades de navegacion y un agente con reglas de trabajo personalizadas.

## Estructura

- `joseca_config.ps1`: perfil de PowerShell para desktop.
- `joseca_config_laptop.ps1`: perfil de PowerShell para laptop.
- `omp-themes/`: temas personalizados de `oh-my-posh`.
- `opencode/`: configuracion, instrucciones y agentes de OpenCode.
- `yasb/`: configuracion y estilos de la barra de YASB.
  - `yasb/setup-yasb.ps1`: aplica la configuracion en Windows y respalda la anterior.

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

## Configuracion de YASB

- [`yasb/config.yaml`](yasb/config.yaml): widgets y comportamiento de la barra.
- [`yasb/styles.css`](yasb/styles.css): apariencia de la barra y sus menus.

### Restauracion

1. Instala [YASB](https://github.com/amnweb/yasb) y **GeistMono Nerd Font Mono** para los iconos y el texto monoespaciado. Los estilos tambien utilizan las fuentes de Windows Segoe UI y Segoe Fluent Icons.
2. Clona este repositorio si aun no esta en la computadora:

```powershell
git clone https://github.com/Jose20025/dotfiles.git "$HOME\dotfiles"
```

3. Cierra YASB y ejecuta el script desde la raiz del repositorio. El bypass solo aplica a ese proceso de PowerShell y no cambia la politica permanente:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\yasb\setup-yasb.ps1
```

4. Inicia YASB de nuevo.

El script copia `config.yaml` y `styles.css` a `%USERPROFILE%\.config\yasb` y, si ya existen, los respalda en una carpeta hermana con sufijo `.backup-fecha-hora`. Si `YASB_CONFIG_HOME` esta definido, usa esa ubicacion en su lugar. No instala YASB ni la fuente; asume que ambos ya estan instalados.

### Archivos generados y ajustes locales

- `yasb_colors.css` es generado por YASB y lo importa `styles.css`. La configuracion mantiene `system_colors: true`; no se versiona la paleta generada del equipo.
- Los logs (`*.log` y `*.log.*`) tampoco se versionan. Las exclusiones estan en [`yasb/.gitignore`](yasb/.gitignore).
- El widget `wallpapers` esta desactivado en la lista de widgets de la barra, pero conserva la ruta local `D:\OneDrive\Pictures\Wallpapers\Themes\Monochrome` en `image_path`. Ajustala antes de activar ese widget en otro equipo.
- Los widgets de Komorebi estan desactivados en la barra; solo requieren Komorebi si decides activarlos.

Los archivos de `yasb/` son una copia, no un enlace a la configuracion instalada. Si personalizas la barra desde su carpeta local, copia de nuevo `config.yaml` y `styles.css` al repositorio para guardar esos cambios.

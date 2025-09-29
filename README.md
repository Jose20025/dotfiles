# Configuración de PowerShell personalizada

Este repositorio contiene una configuración personalizada para PowerShell, incluyendo temas para [oh-my-posh](https://ohmyposh.dev/) y algunos alias útiles.

## Uso

Para aplicar esta configuración en tu perfil de PowerShell, simplemente agrega una línea en tu archivo de perfil (`$PROFILE`) que haga referencia a este script usando dot-source.

Por ejemplo, si este archivo está ubicado en `D:\dotfiles\joseca_config.ps1`, añade lo siguiente a tu perfil:

```powershell
. D:\dotfiles\joseca_config.ps1
```

> **Nota:** El punto al inicio (`.`) es importante, ya que permite que las funciones y configuraciones definidas en el script estén disponibles en tu sesión actual.

## ¿Qué incluye?

- Inicialización de [oh-my-posh](https://ohmyposh.dev/) con el tema definido en [`omp-themes/amro.omp.json`](omp-themes/amro.omp.json).
- Importación del módulo [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) para mejorar la visualización de archivos y carpetas.
- Alias rápidos para navegar a carpetas de desarrollo:
  - `godev` para ir a `D:\dev`
  - `gokais` para ir a `D:/work/kais`

## Personalización

Si prefieres otro tema, puedes cambiar la línea:

```powershell
$omp_config = Join-Path $script:Root 'omp-themes\amro.omp.json'
```

por

```powershell
$omp_config = Join-Path $script:Root 'omp-themes\pure.omp.json'
```

y reiniciar tu terminal.

---

¡Disfruta tu terminal personalizada!
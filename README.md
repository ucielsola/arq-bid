# Arq Bid

Aplicación macOS de barra de menú que muestra el valor `bid` de USDC/ARS desde la API de Arq Finance.

## Desarrollo

Requiere macOS 13 o superior y Xcode instalado.

```bash
swift run
```

La aplicación consulta la API al iniciar, permite actualizar manualmente y vuelve a consultar cada 15 minutos.

Para validar la lógica de la API sin instalar la aplicación:

\`\`\`bash
swift run ArqBidCoreChecks
\`\`\`

Para generar una aplicación instalable localmente:

```bash
./scripts/build-app.sh
open ArqBid.app
```

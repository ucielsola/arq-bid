# Arq Bid

Aplicación macOS de barra de menú que muestra el valor `bid` de USDC/ARS desde la API de Arq Finance.

## Desarrollo

Requiere macOS 13 o superior y Xcode instalado.

```bash
swift run
```

La aplicación consulta la API al iniciar, permite actualizar manualmente y vuelve a consultar cada 15 minutos. Conserva localmente las últimas 100 muestras y muestra la variación acumulada desde la más antigua disponible.

Para validar la lógica de la API sin instalar la aplicación:

\`\`\`bash
swift run ArqBidCoreChecks
\`\`\`

El código del widget está en \`Sources/ArqBidWidget\`. El target compila con:

\`\`\`bash
swift build --product ArqBidWidget
\`\`\`

Para instalarlo en macOS, agregá un target **Widget Extension** en Xcode usando esos archivos, \`Resources/WidgetInfo.plist\` como \`Info.plist\` y la dependencia \`ArqBidCore\`. macOS admite las familias \`systemSmall\` y \`systemMedium\`; \`accessoryRectangular\` no está disponible para widgets de macOS.

Para generar una aplicación instalable localmente:

```bash
./scripts/build-app.sh
open ArqBid.app
```

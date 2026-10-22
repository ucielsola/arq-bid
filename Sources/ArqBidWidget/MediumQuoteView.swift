import ArqBidCore
import SwiftUI

struct MediumQuoteView: View {
    let entry: ArqBidWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            WidgetHeader(entry: entry)

            Text(CurrencyFormatter.string(from: entry.usdcARS))
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .foregroundStyle(WidgetColors.ink)
                .minimumScaleFactor(0.75)
                .lineLimit(1)

            Divider()
                .overlay(WidgetColors.divider)

            HStack {
                Text("EURC / ARS")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(WidgetColors.ink)
                Spacer()
                Text(CurrencyFormatter.string(from: entry.eurcARS))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(WidgetColors.ink)
                    .monospacedDigit()
            }

            TrendPanel(entry: entry)

            Text("Actualizado \(entry.updatedAt, style: .relative)")
                .font(.caption)
                .foregroundStyle(WidgetColors.secondaryInk)

            Divider()
                .overlay(WidgetColors.divider)

            Label("Actualizar ahora", systemImage: "arrow.clockwise")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(WidgetColors.ink)
                .accessibilityLabel("Actualizar cotizaciones ahora")
        }
        .padding(18)
    }
}

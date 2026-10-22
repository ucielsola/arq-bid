import ArqBidCore
import SwiftUI

struct SmallQuoteView: View {
    let entry: ArqBidWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WidgetHeader(entry: entry, compact: true)
            Spacer(minLength: 0)
            Text(CurrencyFormatter.string(from: entry.usdcARS))
                .font(.title.weight(.bold))
                .foregroundStyle(WidgetColors.ink)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
            Text("Actualizado \(entry.updatedAt, style: .relative)")
                .font(.caption2)
                .foregroundStyle(WidgetColors.secondaryInk)
                .lineLimit(1)
        }
        .padding(14)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("USDC sobre pesos argentinos")
        .accessibilityValue("\(CurrencyFormatter.string(from: entry.usdcARS)). Actualizado \(entry.updatedAt, style: .relative)")
    }
}

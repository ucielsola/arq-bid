import SwiftUI

struct WidgetHeader: View {
    let entry: ArqBidWidgetEntry
    var compact = false

    var body: some View {
        HStack(spacing: 6) {
            Text("USDC / ARS")
                .font((compact ? Font.subheadline : Font.headline).weight(.semibold))
                .foregroundStyle(WidgetColors.ink)
            Circle()
                .fill(entry.isStale ? WidgetColors.stale : WidgetColors.live)
                .frame(width: 7, height: 7)
                .accessibilityHidden(true)
            if !compact {
                Text("Valor bid")
                    .font(.caption)
                    .foregroundStyle(WidgetColors.secondaryInk)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(entry.isStale ? "USDC sobre pesos argentinos, desactualizado" : "USDC sobre pesos argentinos, en vivo")
    }
}

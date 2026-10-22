import SwiftUI

struct TrendPanel: View {
    let entry: ArqBidWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Variación · \(entry.recordCount) registros")
                .font(.caption)
                .foregroundStyle(WidgetColors.panelSecondary)

            if let usdcChange = entry.usdcChange {
                WidgetChangeRow(title: "USDC / ARS", change: usdcChange)
            }
            if let eurcChange = entry.eurcChange {
                WidgetChangeRow(title: "EURC / ARS", change: eurcChange)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(WidgetColors.panel, in: .rect(cornerRadius: 14))
    }
}

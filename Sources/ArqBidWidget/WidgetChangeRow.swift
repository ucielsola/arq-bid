import ArqBidCore
import SwiftUI

struct WidgetChangeRow: View {
    let title: String
    let change: RateChange

    var body: some View {
        HStack {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(WidgetColors.panelSecondary)
            Spacer()
            Label {
                Text("\(CurrencyFormatter.string(from: change.absolute)) (\(CurrencyFormatter.percentString(from: change.percentage)))")
                    .font(.caption.weight(.bold))
                    .monospacedDigit()
            } icon: {
                Image(systemName: change.isNegative ? "arrow.down.right" : "arrow.up.right")
            }
            .foregroundStyle(change.isNegative ? WidgetColors.down : WidgetColors.up)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), variación \(CurrencyFormatter.string(from: change.absolute)), \(CurrencyFormatter.percentString(from: change.percentage))")
    }
}

import ArqBidCore
import SwiftUI

struct ChangeRow: View {
    let title: String
    let change: RateChange

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))
            Spacer()
            Image(systemName: iconName)
            Text("\(CurrencyFormatter.string(from: change.absolute)) (\(CurrencyFormatter.percentString(from: change.percentage)))")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
        }
        .foregroundStyle(changeColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), variación \(CurrencyFormatter.string(from: change.absolute)), \(CurrencyFormatter.percentString(from: change.percentage))")
    }

    private var iconName: String {
        if change.isPositive { return "arrow.up.right" }
        if change.isNegative { return "arrow.down.right" }
        return "arrow.right"
    }

    private var changeColor: Color {
        if change.isPositive { return .green }
        if change.isNegative { return .red }
        return .secondary
    }
}

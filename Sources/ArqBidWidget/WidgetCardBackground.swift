import SwiftUI

struct WidgetCardBackground: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 14.0, *) {
            content.containerBackground(WidgetColors.card, for: .widget)
        } else {
            content.background(WidgetColors.card)
        }
    }
}

import SwiftUI
import WidgetKit

struct ArqBidWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: ArqBidWidgetEntry

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallQuoteView(entry: entry)
            default:
                MediumQuoteView(entry: entry)
            }
        }
        .modifier(WidgetCardBackground())
    }
}

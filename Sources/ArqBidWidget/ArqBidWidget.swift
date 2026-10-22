import WidgetKit
import SwiftUI

@main
struct ArqBidWidget: Widget {
    private let kind = "ArqBidWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ArqBidTimelineProvider()) { entry in
            ArqBidWidgetView(entry: entry)
        }
        .configurationDisplayName("Arq Bid")
        .description("Cotizaciones bid de USDC/ARS y EURC/ARS.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

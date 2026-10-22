import SwiftUI
import WidgetKit

struct ArqBidWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        ArqBidWidgetView(entry: .mock())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small")
    }
}

struct ArqBidWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        ArqBidWidgetView(entry: .mock())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium")
    }
}

import ArqBidCore
import WidgetKit

struct ArqBidWidgetEntry: TimelineEntry {
    let date: Date
    let usdcARS: Decimal
    let eurcARS: Decimal
    let updatedAt: Date
    let isStale: Bool
    let recordCount: Int
    let usdcChange: RateChange?
    let eurcChange: RateChange?

    static func mock(date: Date = .now, isStale: Bool = false) -> Self {
        Self(
            date: date,
            usdcARS: Decimal(string: "1641.38") ?? 0,
            eurcARS: Decimal(string: "1841.93") ?? 0,
            updatedAt: date.addingTimeInterval(-9),
            isStale: isStale,
            recordCount: 4,
            usdcChange: RateChange(from: 1640.56, to: 1641.38),
            eurcChange: RateChange(from: 1840.52, to: 1841.93)
        )
    }
}

import ArqBidCore
import WidgetKit

struct ArqBidTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> ArqBidWidgetEntry {
        .mock()
    }

    func getSnapshot(in context: Context, completion: @escaping (ArqBidWidgetEntry) -> Void) {
        completion(.mock())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ArqBidWidgetEntry>) -> Void
    ) {
        Task {
            let entry = await fetchEntry()
            let nextUpdate = Calendar.current.date(
                byAdding: .minute,
                value: 15,
                to: .now
            ) ?? .now.addingTimeInterval(15 * 60)
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    private func fetchEntry() async -> ArqBidWidgetEntry {
        do {
            let rates = try await ArqFinanceService().fetchRates()
            return ArqBidWidgetEntry(
                date: .now,
                usdcARS: rates.usdcARS,
                eurcARS: rates.eurcARS,
                updatedAt: rates.date,
                isStale: false,
                recordCount: 1,
                usdcChange: nil,
                eurcChange: nil
            )
        } catch {
            return .mock(date: .now, isStale: true)
        }
    }
}

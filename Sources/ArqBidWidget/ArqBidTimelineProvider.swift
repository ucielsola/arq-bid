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
            let historyStore = RateHistoryStore()
            var history = historyStore.load()
            history.append(RateSnapshot(
                date: rates.date,
                usdcARS: rates.usdcARS,
                eurcARS: rates.eurcARS
            ))
            historyStore.save(history)

            return ArqBidWidgetEntry(
                date: .now,
                usdcARS: rates.usdcARS,
                eurcARS: rates.eurcARS,
                updatedAt: rates.date,
                isStale: false,
                recordCount: history.snapshots.count,
                usdcChange: history.change(for: .usdcARS),
                eurcChange: history.change(for: .eurcARS)
            )
        } catch {
            return .mock(date: .now, isStale: true)
        }
    }
}

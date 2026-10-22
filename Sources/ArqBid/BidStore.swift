import ArqBidCore
import Combine
import Foundation

@MainActor
final class BidStore: ObservableObject {
    @Published private(set) var usdcARS: Decimal?
    @Published private(set) var eurcARS: Decimal?
    @Published private(set) var updatedAt: Date?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service = ArqFinanceService()
    private var refreshTask: Task<Void, Never>?

    var menuBarTitle: String {
        guard let usdcARS else { return "USDC —" }
        return "USDC \(CurrencyFormatter.string(from: usdcARS))"
    }

    init() {
        refreshTask = Task { [weak self] in
            await self?.refreshLoop()
        }
    }

    deinit {
        refreshTask?.cancel()
    }

    func refresh() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let rates = try await service.fetchRates()
            usdcARS = rates.usdcARS
            eurcARS = rates.eurcARS
            updatedAt = rates.date
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func refreshLoop() async {
        await refresh()

        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(15 * 60))
            guard !Task.isCancelled else { return }
            await refresh()
        }
    }
}

import SwiftUI

@main
struct ArqBidApp: App {
    @StateObject private var store = BidStore()

    var body: some Scene {
        MenuBarExtra {
            BidPopover(store: store)
        } label: {
            Label(store.menuBarTitle, systemImage: "dollarsign.circle")
                .labelStyle(.titleAndIcon)
        }
        .menuBarExtraStyle(.window)
    }
}

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

struct BidPopover: View {
    @ObservedObject var store: BidStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("USDC / ARS")
                        .font(.headline)
                    Text("Valor bid")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.green)
            }

            if let usdcARS = store.usdcARS {
                Text(CurrencyFormatter.string(from: usdcARS))
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
            } else if store.isLoading {
                ProgressView()
            } else {
                Text("Sin datos")
                    .foregroundStyle(.secondary)
            }

            if let eurcARS = store.eurcARS {
                RateRow(title: "EURC / ARS", value: CurrencyFormatter.string(from: eurcARS))
            }

            if let updatedAt = store.updatedAt {
                Text("Actualizado \(updatedAt, style: .relative)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage = store.errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()

            Button {
                Task { await store.refresh() }
            } label: {
                Label("Actualizar ahora", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .disabled(store.isLoading)

            Button("Salir") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .frame(width: 280)
        .padding(18)
        .modifier(ClearWindowBackground())
    }
}

struct RateRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline.weight(.semibold))
                .monospacedDigit()
        }
    }
}

struct ClearWindowBackground: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 15.0, *) {
            content.containerBackground(.clear, for: .window)
        } else {
            content
        }
    }
}

struct ArqTicker: Decodable {
    let book: String
    let bid: String
    let date: Date
}

struct ArqRates {
    let usdcARS: Decimal
    let eurcARS: Decimal
    let date: Date
}

struct ArqFinanceService {
    private let endpoint = URL(string: "https://api.arqfinance.com/v1/tickers?currencies=ARS,EURC")!

    func fetchRates() async throws -> ArqRates {
        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let value = try decoder.singleValueContainer().decode(String.self)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
            guard let date = formatter.date(from: value) else {
                throw APIError.invalidDate
            }
            return date
        }

        let tickers = try decoder.decode([ArqTicker].self, from: data)
        guard let usdcARSTicker = tickers.first(where: { $0.book == "usdc_ars" }),
              let usdcEURCTicker = tickers.first(where: { $0.book == "usdc_eurc" }),
              let usdcARS = Decimal(string: usdcARSTicker.bid),
              let usdcEURC = Decimal(string: usdcEURCTicker.bid),
              usdcEURC != 0 else {
            throw APIError.emptyResponse
        }

        return ArqRates(
            usdcARS: usdcARS,
            eurcARS: usdcARS / usdcEURC,
            date: usdcARSTicker.date
        )
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case invalidDate
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "La API no respondió correctamente."
        case .invalidDate:
            return "La API devolvió una fecha inválida."
        case .emptyResponse:
            return "La API no devolvió cotizaciones."
        }
    }
}

enum CurrencyFormatter {
    static func string(from value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "ARS"
        formatter.locale = Locale(identifier: "es_AR")
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "—"
    }
}

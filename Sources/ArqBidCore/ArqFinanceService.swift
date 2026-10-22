import Foundation

public struct ArqFinanceService: Sendable {
    private static let endpointString = "https://api.arqfinance.com/v1/tickers?currencies=ARS,EURC"

    public init() {}

    public func fetchRates() async throws -> ArqRates {
        guard let endpoint = URL(string: Self.endpointString) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: endpoint)
        request.timeoutInterval = 15
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        return try Self.decodeRates(from: data)
    }

    public static func decodeRates(from data: Data) throws -> ArqRates {
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

        // The API exposes EURC through the USDC/EURC market, so derive the
        // EURC/ARS bid from the two bid prices.
        return ArqRates(
            usdcARS: usdcARS,
            eurcARS: usdcARS / usdcEURC,
            date: usdcARSTicker.date
        )
    }
}

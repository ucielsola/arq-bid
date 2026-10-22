import Foundation

public struct RateSnapshot: Codable, Equatable, Sendable {
    public let date: Date
    public let usdcARS: Decimal
    public let eurcARS: Decimal

    public init(date: Date, usdcARS: Decimal, eurcARS: Decimal) {
        self.date = date
        self.usdcARS = usdcARS
        self.eurcARS = eurcARS
    }
}

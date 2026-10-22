import Foundation

public struct ArqRates: Equatable, Sendable {
    public let usdcARS: Decimal
    public let eurcARS: Decimal
    public let date: Date

    public init(usdcARS: Decimal, eurcARS: Decimal, date: Date) {
        self.usdcARS = usdcARS
        self.eurcARS = eurcARS
        self.date = date
    }
}

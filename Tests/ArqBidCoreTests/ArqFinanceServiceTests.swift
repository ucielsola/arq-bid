import Foundation
import ArqBidCore

@main
struct ArqBidCoreChecks {
    static func main() throws {
        try decodesBothMarketsAndCalculatesEurcArs()
        checksHistoryLimitAndChange()
        rejectsResponseWithoutExpectedMarkets()
        rejectsInvalidDatePrecision()
        print("ArqBidCoreChecks: 4 checks passed")
    }

    private static func decodesBothMarketsAndCalculatesEurcArs() throws {
        let data = Data(
            """
            [
              {"book":"usdc_ars","bid":"1638.1502100000","ask":"1641.2600000000","date":"2026-10-22T14:25:05.270794581"},
              {"book":"usdc_eurc","bid":"0.8931012353","ask":"0.8934984546","date":"2026-10-22T14:25:05.274884875"}
            ]
            """.utf8
        )

        let rates = try ArqFinanceService.decodeRates(from: data)

        precondition(rates.usdcARS == Decimal(string: "1638.1502100000"))
        let calculated = (rates.eurcARS as NSDecimalNumber).doubleValue
        precondition(abs(calculated - 1834.2267877949267) < 0.0000001)
    }

    private static func rejectsResponseWithoutExpectedMarkets() {
        let data = Data(
            """
            [{"book":"usdc_ars","bid":"1638.15","ask":"1641.26","date":"2026-10-22T14:25:05.270794581"}]
            """.utf8
        )

        do {
            _ = try ArqFinanceService.decodeRates(from: data)
            preconditionFailure("Expected emptyResponse")
        } catch {
            precondition((error as? APIError) == .emptyResponse)
        }
    }

    private static func checksHistoryLimitAndChange() {
        var history = RateHistory(maxCount: 2)
        history.append(RateSnapshot(date: .now, usdcARS: 100, eurcARS: 200))
        history.append(RateSnapshot(date: .now.addingTimeInterval(1), usdcARS: 110, eurcARS: 190))
        history.append(RateSnapshot(date: .now.addingTimeInterval(2), usdcARS: 120, eurcARS: 180))

        precondition(history.snapshots.count == 2)
        precondition(history.snapshots.first?.usdcARS == 110)
        precondition(history.change(for: .usdcARS)?.absolute == 10)
        let percentage = history.change(for: .usdcARS)?.percentage
        precondition(percentage.map { abs(($0 as NSDecimalNumber).doubleValue - 9.090909090909092) < 0.0000001 } == true)
    }

    private static func rejectsInvalidDatePrecision() {
        let data = Data(
            """
            [{"book":"usdc_ars","bid":"1638.15","ask":"1641.26","date":"not-a-date"}]
            """.utf8
        )

        do {
            _ = try ArqFinanceService.decodeRates(from: data)
            preconditionFailure("Expected invalidDate")
        } catch {
            precondition((error as? APIError) == .invalidDate)
        }
    }
}

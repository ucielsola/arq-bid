import Foundation
import ArqBidCore

@main
struct ArqBidCoreChecks {
    static func main() throws {
        try decodesBothMarketsAndCalculatesEurcArs()
        rejectsResponseWithoutExpectedMarkets()
        rejectsInvalidDatePrecision()
        print("ArqBidCoreChecks: 3 checks passed")
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

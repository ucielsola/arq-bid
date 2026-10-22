import Foundation

public struct ArqTicker: Decodable, Equatable, Sendable {
    public let book: String
    public let bid: String
    public let date: Date

    public init(book: String, bid: String, date: Date) {
        self.book = book
        self.bid = bid
        self.date = date
    }
}

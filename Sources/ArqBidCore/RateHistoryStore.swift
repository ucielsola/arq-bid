import Foundation

public struct RateHistoryStore {
    private let defaults: UserDefaults
    private let key: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(
        defaults: UserDefaults = .standard,
        key: String = "arqBid.rateHistory"
    ) {
        self.defaults = defaults
        self.key = key
    }

    public func load(maxCount: Int = 100) -> RateHistory {
        guard let data = defaults.data(forKey: key),
              let snapshots = try? decoder.decode([RateSnapshot].self, from: data) else {
            return RateHistory(maxCount: maxCount)
        }
        return RateHistory(snapshots: snapshots, maxCount: maxCount)
    }

    public func save(_ history: RateHistory) {
        guard let data = try? encoder.encode(history.snapshots) else { return }
        defaults.set(data, forKey: key)
    }
}

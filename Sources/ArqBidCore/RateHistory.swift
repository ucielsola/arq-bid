import Foundation

public enum RateAsset: Sendable {
    case usdcARS
    case eurcARS
}

public struct RateChange: Equatable, Sendable {
    public let absolute: Decimal
    public let percentage: Decimal

    public var isPositive: Bool { absolute > 0 }
    public var isNegative: Bool { absolute < 0 }

    public init(from oldValue: Decimal, to newValue: Decimal) {
        absolute = newValue - oldValue
        percentage = oldValue == 0 ? 0 : (absolute / oldValue) * 100
    }
}

public struct RateHistory: Codable, Equatable, Sendable {
    public private(set) var snapshots: [RateSnapshot]
    public let maxCount: Int

    public init(snapshots: [RateSnapshot] = [], maxCount: Int = 100) {
        self.maxCount = max(1, maxCount)
        self.snapshots = Array(snapshots.suffix(self.maxCount))
    }

    public mutating func append(_ snapshot: RateSnapshot) {
        snapshots.append(snapshot)
        if snapshots.count > maxCount {
            snapshots.removeFirst(snapshots.count - maxCount)
        }
    }

    public func change(for asset: RateAsset) -> RateChange? {
        guard let oldest = snapshots.first, let latest = snapshots.last, oldest != latest else {
            return nil
        }

        switch asset {
        case .usdcARS:
            return RateChange(from: oldest.usdcARS, to: latest.usdcARS)
        case .eurcARS:
            return RateChange(from: oldest.eurcARS, to: latest.eurcARS)
        }
    }
}

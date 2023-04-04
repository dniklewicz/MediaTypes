//  Created by Dariusz Niklewicz on 18/12/2022.

import Foundation

public enum RepeatMode: String, CaseIterable {
    case all = "on_all"
    case one = "on_one"
    case off

    public var displayString: String {
        switch self {
        case .all: return "ALL"
        case .one: return "ONE"
        case .off: return "OFF"
        }
    }

    public func next() -> RepeatMode {
        switch self {
        case .all: return .one
        case .one: return .off
        case .off: return .all
        }
    }
}

public enum ShuffleMode: String, CaseIterable {
    case on
    case off

    public var displayString: String {
        return rawValue.uppercased()
    }

    public func next() -> ShuffleMode {
        switch self {
        case .on: return .off
        case .off: return .on
        }
    }
}

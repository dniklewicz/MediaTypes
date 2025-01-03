//  Created by Dariusz Niklewicz on 18/12/2022.

import Foundation

public enum RepeatMode: String, CaseIterable, Hashable {
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

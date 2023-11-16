//
//  File.swift
//  
//
//  Created by Dariusz Niklewicz on 07/11/2023.
//

import Foundation

public enum ShuffleMode: String, CaseIterable, Equatable {
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

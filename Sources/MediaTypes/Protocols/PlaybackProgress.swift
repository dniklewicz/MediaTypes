//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public struct PlaybackProgress: Equatable {
    public let currentTime: TimeInterval
    public let totalTime: TimeInterval
	public var progress: Double {
		currentTime / totalTime
	}
	public var remainingTime: TimeInterval {
		totalTime - currentTime
	}

    public init(currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
        self.totalTime = totalTime
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.currentTime == rhs.currentTime && lhs.totalTime == rhs.totalTime
    }
}

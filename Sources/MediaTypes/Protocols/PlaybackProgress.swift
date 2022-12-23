//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public struct PlaybackProgress {
    public let currentTime: TimeInterval
    public let totalTime: TimeInterval
    
    public init(currentTime: TimeInterval, totalTime: TimeInterval) {
        self.currentTime = currentTime
        self.totalTime = totalTime
    }
}

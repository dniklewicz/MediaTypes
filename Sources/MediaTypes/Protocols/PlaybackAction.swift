//  Created by Dariusz Niklewicz on 18/12/2022.

import Foundation

public enum PlaybackAction: CaseIterable, Equatable {
    case play
    case stop
    case pause
    case next
    case previous
    case restart
}

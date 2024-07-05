//  Created by Dariusz Niklewicz on 18/12/2022.

import Foundation

public enum PlaybackAction: CaseIterable, Hashable {
    case play
    case stop
    case pause
    case next
    case previous
    case restart
}

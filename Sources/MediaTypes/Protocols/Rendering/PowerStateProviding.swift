//  Created by Dariusz Niklewicz on 21/03/2023.

import Combine
import Foundation

public enum PowerState {
    case on, off, standby
}

public protocol PowerStateProviding {
    var powerState: PowerState { get }
    var powerStatePublisher: Published<PowerState>.Publisher { get }

    func set(powerState: PowerState) async throws
}

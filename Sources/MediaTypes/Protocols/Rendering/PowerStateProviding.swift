//  Created by Dariusz Niklewicz on 21/03/2023.

import Combine
import Foundation

public enum PowerState: Hashable {
    case on, off, standby
}

public protocol PowerStateProviding {
    var powerState: PowerState { get }
    var powerStatePublisher: AnyPublisher<PowerState, Never> { get }

    func set(powerState: PowerState) async throws
}

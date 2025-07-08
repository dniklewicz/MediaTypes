//  Created by Dariusz Niklewicz on 19/12/2022.

import Combine
import Foundation

public protocol GroupableMediaRenderer: MediaRenderer {
    associatedtype RenderingGroup: MediaRenderingGroup

    var zoneVolume: Int { get }
    var zoneVolumePublisher: AnyPublisher<Int, Never> { get }

    var zoneMute: Bool { get }
    var zoneMutePublisher: AnyPublisher<Bool, Never> { get }

    var group: RenderingGroup? { get }
    var groupPublisher: AnyPublisher<RenderingGroup?, Never> { get }

    func createGroup(withMembers members: [ID]) async throws
    func addToGroup(member: ID) async throws
    func leaveGroup() async throws
    func set(zoneVolume: Int) async throws
    func set(zoneMute: Bool) async throws
}

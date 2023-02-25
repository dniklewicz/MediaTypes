//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol GroupableMediaRenderer: MediaRenderer {
    associatedtype RenderingGroup: MediaRenderingGroup
    where Self.ID == RenderingGroup.Renderer.ID
    
    var zoneVolume: Int { get }
    var zoneVolumePublished: Published<Int> { get }
    var zoneVolumePublisher: Published<Int>.Publisher { get }
    
    var zoneMute: Bool { get }
    var zoneMutePublished: Published<Bool> { get }
    var zoneMutePublisher: Published<Bool>.Publisher { get }
    
    var group: RenderingGroup? { get }
    var groupPublished: Published<RenderingGroup?> { get }
    var groupPublisher: Published<RenderingGroup?>.Publisher { get }
    
    func createGroup(withMembers members: [ID]) async throws
    func addToGroup(member: ID) async throws
    func leaveGroup() async throws
    func set(zoneVolume: Int) async throws
    func set(zoneMute: Bool) async throws
}

//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol GroupableMediaRenderer: MediaRenderer {
    associatedtype RenderingGroup: MediaRenderingGroup
    where Self.ID == RenderingGroup.Renderer.ID
    
    var group: RenderingGroup? { get }
    var groupPublished: Published<RenderingGroup?> { get }
    var groupPublisher: Published<RenderingGroup?>.Publisher { get }
    
    func createGroup(withMembers members: [ID])
    func addToGroup(member: ID)
    func leaveGroup()
}

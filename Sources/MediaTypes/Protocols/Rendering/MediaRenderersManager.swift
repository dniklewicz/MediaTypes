//  Created by Dariusz Niklewicz on 19/12/2022.

import Combine
import Foundation

public protocol MediaRenderersManager {
    associatedtype Renderer: MediaRenderer

    var renderers: [Renderer] { get }
    var renderersPublisher: Published<[Renderer]>.Publisher { get }

    func renderer(withName name: String) -> Renderer?
    func renderer(withId id: Renderer.ID) -> Renderer?

    func process(deviceDescription: String, ipAddress: String, port: Int) -> Bool
}

public extension MediaRenderersManager {
    func renderer(withName name: String) -> Renderer? {
        renderers.first(where: { $0.name == name })
    }

    func renderer(withId id: Renderer.ID) -> Renderer? {
        renderers.first(where: { $0.id == id })
    }
}

public protocol GroupableMediaRenderersManager: MediaRenderersManager where Renderer: GroupableMediaRenderer {
    associatedtype Group: MediaRenderingGroup
    where Group.Renderer == Renderer

    var groups: [Group] { get }
    var groupsPublisher: Published<[Group]>.Publisher { get }
}

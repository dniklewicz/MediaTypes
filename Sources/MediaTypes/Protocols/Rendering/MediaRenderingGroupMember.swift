//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol MediaRenderingGroupMember<Renderer>: Codable {
    associatedtype Renderer: MediaRenderer
    var id: String { get }
    var role: MediaRenderingGroupMemberRole { get }
}

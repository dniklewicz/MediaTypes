//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol MediaRenderingGroupMember<Renderer>: Codable, Identifiable, Equatable {
    associatedtype Renderer: MediaRenderer
    var id: String { get }
    var role: MediaRenderingGroupMemberRole { get }
	var name: String { get }
}

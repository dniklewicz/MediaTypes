//  Created by Dariusz Niklewicz on 19/12/2022.

import Foundation

public protocol MediaRenderingGroup<Member>: Identifiable {
    associatedtype Renderer: GroupableMediaRenderer
    associatedtype Member: MediaRenderingGroupMember<Renderer>

    var name: String { get }
    // All members with leader at first index.
    var members: [Member] { get }
}

public extension MediaRenderingGroup {
    var leaderId: String? { members.first { $0.role == .leader }?.id }
	func role(for id: String) -> MediaRenderingGroupMemberRole? {
		members.first { $0.id == id }?.role
    }
}

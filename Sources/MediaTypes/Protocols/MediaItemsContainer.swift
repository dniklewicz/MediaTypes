//  Created by Dariusz Niklewicz on 07/10/2021.

import Foundation

public protocol MediaSearchCriteria: Identifiable, Hashable, Equatable {
    var name: String { get }

    init()
}

extension MediaSearchCriteria {
    public var id: String { name }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct NotSearchableCriteria: MediaSearchCriteria {
    public var name: String { "Not searchable" }
    public var id: Int { 0 }

    public init() {}
}

struct MediaItemsContainerResponse {
	let mediaItems: [any MediaItem]
	let totalCount: Int?
}

public protocol MediaItemsContainer: MediaItem {
    associatedtype SearchCriteria: MediaSearchCriteria

    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    var isAvailable: Bool { get }
    var searchCriteria: [SearchCriteria] { get }
    var isActiveContainer: Bool? { get }
	var supportsItemsHiding: Bool { get }

    func search(
        for keyword: String,
        using: SearchCriteria,
		range: ClosedRange<Int>,
		isFirstSearch: Bool
    ) async throws -> [any MediaItem]
	
	func searchWillCancel()

	func getItems(range: ClosedRange<Int>) async throws -> ([any MediaItem], Int?)
}

public extension MediaItemsContainer {
    var isAvailable: Bool {
        true
    }

    var searchable: Bool {
        searchCriteria.count > 0
    }
	
	var supportsItemsHiding: Bool { false }
	
	func search(
		for keyword: String,
		using: SearchCriteria,
		range: ClosedRange<Int>
	) async throws -> [any MediaItem] {
		try await search(for: keyword, using: using, range: range, isFirstSearch: false)
	}
}

public extension MediaItemsContainer
where SearchCriteria == NotSearchableCriteria {
    var searchCriteria: [SearchCriteria] { [] }
    func search(
        for keyword: String,
        using: SearchCriteria,
		isFirstSearch: Bool
    ) async throws -> [any MediaItem] {
        []
    }
	
	func searchWillCancel() {}
}

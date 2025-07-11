//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Combine
import Foundation

public class ItemsCollection<SearchCriteria: MediaSearchCriteria>: MediaItemsContainer {
	public static func == (lhs: ItemsCollection<SearchCriteria>, rhs: ItemsCollection<SearchCriteria>) -> Bool {
		lhs.typeString == rhs.typeString
		&& lhs.metadata == rhs.metadata
		&& lhs.searchCriteria == rhs.searchCriteria
		&& lhs.thumbnail == rhs.thumbnail
		&& lhs.displayTitle == rhs.displayTitle
		&& lhs.displaySubtitle == rhs.displaySubtitle
		&& lhs.isActiveContainer == rhs.isActiveContainer
	}
	
    public var typeString: String? { nil }
    public var metadata: MediaItemMetadata? { nil }

    @Published public var searchCriteria: [SearchCriteria] = []
    public var searchCriteriaPublisher: AnyPublisher<[SearchCriteria], Never> { $searchCriteria.eraseToAnyPublisher() }

    public let thumbnail: Artwork?
    public let displayTitle: String
    public let displaySubtitle: String?
	let itemsProvider: ((@escaping (([any MediaItem]) -> Void)) -> Void)
    public var isActiveContainer: Bool? { nil }

    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
		itemsProvider: @escaping ((@escaping (([any MediaItem]) -> Void)) -> Void)
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = itemsProvider
    }

    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
		items: [any MediaItem]
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = { result in
            result(items)
        }
    }
    
	public func search(for keyword: String, using: SearchCriteria, range: ClosedRange<Int>, isFirstSearch: Bool) async throws -> [any MediaItem] { [] }
    public func searchWillCancel() {}

	public func getItems(range: ClosedRange<Int>) async throws -> ([any MediaItem], Int?) {
		try await withCheckedThrowingContinuation { continuation in
			itemsProvider { mediaItems in
				continuation.resume(returning: (mediaItems, mediaItems.count))
			}
		}
	}
}

public class PlayableItemsCollection<SearchCriteria: MediaSearchCriteria>: PlayableMediaItemsContainer {
	public static func == (lhs: PlayableItemsCollection<SearchCriteria>, rhs: PlayableItemsCollection<SearchCriteria>) -> Bool {
		lhs.typeString == rhs.typeString
		&& lhs.metadata == rhs.metadata
		&& lhs.searchCriteria == rhs.searchCriteria
		&& lhs.thumbnail == rhs.thumbnail
		&& lhs.displayTitle == rhs.displayTitle
		&& lhs.displaySubtitle == rhs.displaySubtitle
		&& lhs.isActiveContainer == rhs.isActiveContainer
	}
	
    public var typeString: String? { nil }
    public var metadata: MediaItemMetadata? { nil }

    @Published public var searchCriteria: [SearchCriteria] = []
    public var searchCriteriaPublisher: AnyPublisher<[SearchCriteria], Never> { $searchCriteria.eraseToAnyPublisher() }

    public let thumbnail: Artwork?
    public let displayTitle: String
    public let displaySubtitle: String?
	public let itemsProvider: ((@escaping (([any MediaItem]) -> Void)) -> Void)
    public var isActiveContainer: Bool? { nil }

    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
		itemsProvider: @escaping ((@escaping (([any MediaItem]) -> Void)) -> Void)
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = itemsProvider
    }

    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
		items: [any MediaItem]
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = { result in
            result(items)
        }
    }
    
	public func search(for keyword: String, using: SearchCriteria, range: ClosedRange<Int>, isFirstSearch: Bool) async throws -> [any MediaItem] { [] }
    public func searchWillCancel() {}

	public func getItems(range: ClosedRange<Int>) async throws -> ([any MediaItem], Int?) {
		try await withCheckedThrowingContinuation { continuation in
			itemsProvider { mediaItems in
				continuation.resume(returning: (mediaItems, mediaItems.count))
			}
		}
	}
}

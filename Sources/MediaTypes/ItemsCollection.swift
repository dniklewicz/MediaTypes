//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Combine
import Foundation

public class ItemsCollection<SearchCriteria: MediaSearchCriteria>: MediaItemsContainer {
    public var typeString: String? { nil }
    public var metadata: MediaItemMetadata? { nil }

    @Published public var searchCriteria: [SearchCriteria] = []
    public var searchCriteriaPublished: Published<[SearchCriteria]> { _searchCriteria }
    public var searchCriteriaPublisher: Published<[SearchCriteria]>.Publisher { $searchCriteria }

	public func search(for keyword: String, using: SearchCriteria, isFirstSearch: Bool) async throws -> [any MediaItem] { [] }
	public func searchWillCancel() {}

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
}

public class PlayableItemsCollection<SearchCriteria: MediaSearchCriteria>: PlayableMediaItemsContainer {
    public var typeString: String? { nil }
    public var metadata: MediaItemMetadata? { nil }

    @Published public var searchCriteria: [SearchCriteria] = []
    public var searchCriteriaPublished: Published<[SearchCriteria]> { _searchCriteria }
    public var searchCriteriaPublisher: Published<[SearchCriteria]>.Publisher { $searchCriteria }
	public func search(for keyword: String, using: SearchCriteria, isFirstSearch: Bool) async throws -> [any MediaItem] { [] }
	public func searchWillCancel() {}

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
}

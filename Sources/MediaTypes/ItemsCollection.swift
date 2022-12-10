//
//  ItemsCollection.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import Combine
import Foundation

public struct ItemsCollection<SearchCriteria: MediaSearchCriteria>: MediaItemsContainer {
    public var searchCriteria: [SearchCriteria] = []
    public func search(for keyword: String, using: SearchCriteria, callback: @escaping ([MediaItem]) -> Void) {}
    
    public let thumbnail: Artwork?
    public let displayTitle: String
    public let displaySubtitle: String?
    public let itemsProvider: ((@escaping (([MediaItem]) -> Void)) -> Void)
    
    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
        itemsProvider: @escaping ((@escaping (([MediaItem]) -> Void)) -> Void)
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
        items: [MediaItem]
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = { result in
            result(items)
        }
    }
}

public struct PlayableItemsCollection<SearchCriteria: MediaSearchCriteria>: PlayableMediaItemsContainer {
    public var searchCriteria: [SearchCriteria] = []
    public func search(for keyword: String, using: SearchCriteria, callback: @escaping ([MediaItem]) -> Void) {}
    
    public let thumbnail: Artwork?
    public let displayTitle: String
    public let displaySubtitle: String?
    public let itemsProvider: ((@escaping (([MediaItem]) -> Void)) -> Void)
    
    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork?,
        itemsProvider: @escaping ((@escaping (([MediaItem]) -> Void)) -> Void)
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
        items: [MediaItem]
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.itemsProvider = { result in
            result(items)
        }
    }
}

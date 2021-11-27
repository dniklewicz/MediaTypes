//
//  File.swift
//  
//
//  Created by Dariusz Niklewicz on 07/10/2021.
//

import Foundation

public protocol MediaItemsContainer: MediaItem {
//    associatedtype Item: MediaItem
    
    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    var isAvailable: Bool { get }
    var itemsProvider: ((@escaping (([MediaItem]) -> Void)) -> Void) { get }
    func eraseToAnyMediaItemsContainer() -> AnyMediaItemsContainer
}

public extension MediaItemsContainer {
    var isAvailable: Bool {
        true
    }
    
    func eraseToAnyMediaItemsContainer() -> AnyMediaItemsContainer {
        AnyMediaItemsContainer(item: self)
    }
}

public struct AnyMediaItemsContainer: MediaItemsContainer {
    public var thumbnail: Artwork? {
        item.thumbnail
    }
    
    public var displayTitle: String {
        item.displayTitle
    }
    
    public var displaySubtitle: String? {
        item.displaySubtitle
    }
    
    let item: MediaItemsContainer
    
    public var itemsProvider: ((@escaping (([MediaItem]) -> Void)) -> Void) {
        item.itemsProvider
    }
}

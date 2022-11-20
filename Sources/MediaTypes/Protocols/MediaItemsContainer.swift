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
}

public extension MediaItemsContainer {
    var isAvailable: Bool {
        true
    }
}

//
//  MediaItemType.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import SwiftUI

public protocol MediaItem {
    associatedtype InnerItemType: MediaItem
    
    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    
    var isAvailable: Bool { get }
    var isPlayable: Bool { get }
    
    var containedItems: ItemsCollection<InnerItemType>? { get }
    
//    var containerItemsName: String? { }
//    func fetchContainedItems(completion: ([InnerItemType]) -> Void)
}

public extension MediaItem {
    var isAvailable: Bool { true }
    var isPlayable: Bool { false }
}

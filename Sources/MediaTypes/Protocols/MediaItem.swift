//
//  MediaItemType.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import SwiftUI

public protocol MediaItem {
    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    
    var isAvailable: Bool { get }
    
    func eraseToAnyMediaItem() -> AnyMediaItem
}

public extension MediaItem {
    var isAvailable: Bool { true }
    var isPlayable: Bool { false }
    
    func eraseToAnyMediaItem() -> AnyMediaItem {
        AnyMediaItem(item: self)
    }
}

public protocol PlayableMediaItem: MediaItem, Playable {
    
}

public struct AnyMediaItem: MediaItem {
    public var thumbnail: Artwork? {
        item.thumbnail
    }
    
    public var displayTitle: String {
        item.displayTitle
    }
    
    public var displaySubtitle: String? {
        item.displaySubtitle
    }
    
    let item: MediaItem
}

//
//  EmptyMediaItem.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import SwiftUI

public struct EmptyMediaItem: MediaItem {
    public var thumbnail: Artwork? { nil }
    public var displayTitle: String { "" }
    public var displaySubtitle: String? { nil }
    public var isAvailable: Bool { false }
    public var containedItems: ItemsCollection<EmptyMediaItem>? { nil }
    
    public init() {}
}

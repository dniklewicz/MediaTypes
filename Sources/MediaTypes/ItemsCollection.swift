//
//  ItemsCollection.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import Combine
import Foundation

public struct ItemsCollection<Item: MediaItem> {
    
    public let title: String
    public let itemsProvider: ((@escaping (([Item]) -> Void)) -> Void)
    
    public init(title: String, itemsProvider: @escaping ((@escaping (([Item]) -> Void)) -> Void)) {
        self.title = title
        self.itemsProvider = itemsProvider
    }
    
    public init(title: String, items: [Item]) {
        self.title = title
        self.itemsProvider = { result in
            result(items)
        }
    }
}

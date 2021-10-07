//
//  MediaItemRenderer.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import Foundation

public protocol MediaRenderer {
    associatedtype Item: MediaItem
    
    func play(item: Item)
}

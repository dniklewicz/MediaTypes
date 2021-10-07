//
//  MediaItemRenderer.swift
//  Remote for HEOS
//
//  Created by Dariusz Niklewicz on 17/09/2021.
//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.
//

import Foundation

public protocol MediaItemRenderer {
    associatedtype Item: MediaItemType
    
    func play(item: Item)
}

//
//  File.swift
//  
//
//  Created by Dariusz Niklewicz on 07/10/2021.
//

import Foundation

public protocol MediaSearchCriteria: Identifiable, Hashable {
    var name: String { get }
    
    init()
}

extension MediaSearchCriteria {
    public var id: String { name }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct NotSearchableCriteria: MediaSearchCriteria {
    public var name: String { "Not searchable" }
    public var id: Int { 0 }
    
    public init() {}
}

public protocol MediaItemsContainer: MediaItem {
    associatedtype SearchCriteria: MediaSearchCriteria
    
    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    var isAvailable: Bool { get }
    var itemsProvider: ((@escaping (([MediaItem]) -> Void)) -> Void) { get }
    var searchCriteria: [SearchCriteria] { get }
    
    func search(
        for keyword: String,
        using: SearchCriteria,
        callback: @escaping ([MediaItem]) -> Void
    )
}

public extension MediaItemsContainer {
    var isAvailable: Bool {
        true
    }
    
    var searchable: Bool {
        searchCriteria.count > 0
    }
}

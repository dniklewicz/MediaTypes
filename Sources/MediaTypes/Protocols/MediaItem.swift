//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import SwiftUI

public struct MediaItemMetadata: Equatable {
    public let title: String
    public let artist: String?
    public let album: String?

    public init(title: String, artist: String?, album: String?) {
        self.title = title
        self.artist = artist
        self.album = album
    }
}

public protocol MediaItem: Identifiable {
    var thumbnail: Artwork? { get }
    var displayTitle: String { get }
    var displaySubtitle: String? { get }
    var metadata: MediaItemMetadata? { get }
    var typeString: String? { get }

    var isAvailable: Bool { get }
    var isQueueable: Bool { get }
}

public extension MediaItem {
    var isAvailable: Bool { true }
    var isQueueable: Bool { false }
	var id: String { displayTitle }
}

public protocol PlayableMediaItem: MediaItem, Playable {

}

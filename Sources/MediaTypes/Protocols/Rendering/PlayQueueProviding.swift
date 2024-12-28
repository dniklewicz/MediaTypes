//  Created by Dariusz Niklewicz on 21/03/2023.

import Combine
import Foundation

public enum AddToQueueOption: Int, Hashable {
	case playNow = 1
	case playNext = 2
	case addToEnd = 3
	case replaceAndPlay = 4
}

public protocol PlayQueueProviding {
    associatedtype QueuedItemType: QueuedItem

    var playQueue: [QueuedItemType] { get }
    var playQueuePublisher: Published<[QueuedItemType]>.Publisher { get }

    func updateQueue() async throws
	func addToQueue(item: any MediaItem, option: AddToQueueOption) async throws
    func play(queuedItem: QueuedItemType) async throws
	func removeFromQueue(items: [QueuedItemType]) async throws
}

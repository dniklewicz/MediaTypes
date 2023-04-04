//  Created by Dariusz Niklewicz on 21/03/2023.

import Combine
import Foundation

public protocol PlayQueueProviding {
    associatedtype QueuedItemType: QueuedItem

    var playQueue: [QueuedItemType] { get }
    var playQueuePublished: Published<[QueuedItemType]> { get }
    var playQueuePublisher: Published<[QueuedItemType]>.Publisher { get }

    func updateQueue() async throws
    func addToQueue(item: MediaItem) async throws
    func play(queuedItem: QueuedItemType) async throws
}

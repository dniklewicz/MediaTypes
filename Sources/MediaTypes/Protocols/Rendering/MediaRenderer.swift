//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Foundation

public protocol MediaRenderer: Identifiable
where ID: Codable {
    associatedtype MediaItemType: MediaItem
    associatedtype QueuedItemType: QueuedItem
    
    var name: String { get }
    var model: String { get }
    var ipAddress: String { get }
    
    var playState: PlayState { get }
    var playStatePublished: Published<PlayState> { get }
    var playStatePublisher: Published<PlayState>.Publisher { get }
    
    var volume: Int { get }
    var volumePublished: Published<Int> { get }
    var volumePublisher: Published<Int>.Publisher { get }
    
    var mute: Bool { get }
    var mutePublished: Published<Bool> { get }
    var mutePublisher: Published<Bool>.Publisher { get }
    
    var zoneVolume: Int { get }
    var zoneVolumePublished: Published<Int> { get }
    var zoneVolumePublisher: Published<Int>.Publisher { get }
    
    var zoneMute: Bool { get }
    var zoneMutePublished: Published<Bool> { get }
    var zoneMutePublisher: Published<Bool>.Publisher { get }
    
    var availableActions: [PlaybackAction] { get }
    var availableActionsPublished: Published<[PlaybackAction]> { get }
    var availableActionsPublisher: Published<[PlaybackAction]>.Publisher { get }
    
    var repeatMode: RepeatMode { get }
    var repeatModePublished: Published<RepeatMode> { get }
    var repeatModePublisher: Published<RepeatMode>.Publisher { get }
    
    var shuffleMode: ShuffleMode { get }
    var shuffleModePublished: Published<ShuffleMode> { get }
    var shuffleModePublisher: Published<ShuffleMode>.Publisher { get }
    
    var currentTrack: MediaItemType? { get }
    var currentTrackPublished: Published<MediaItemType?> { get }
    var currentTrackPublisher: Published<MediaItemType?>.Publisher { get }
    
    var playQueue: [QueuedItemType] { get }
    var playQueuePublished: Published<[QueuedItemType]> { get }
    var playQueuePublisher: Published<[QueuedItemType]>.Publisher { get }
    
    var progress: PlaybackProgress? { get }
    var progressPublished: Published<PlaybackProgress?> { get }
    var progressPublisher: Published<PlaybackProgress?>.Publisher { get }
    
    var treble: Int { get }
    var treblePublished: Published<Int> { get }
    var treblePublisher: Published<Int>.Publisher { get }
    
    var bass: Int { get }
    var bassPublished: Published<Int> { get }
    var bassPublisher: Published<Int>.Publisher { get }
    
    func play(item: Playable)
    func set(volume: Int)
    func set(mute: Bool)
    func set(playState: PlayState)
    func set(zoneVolume: Int)
    func set(zoneMute: Bool)
    func set(treble: Int)
    func set(bass: Int)
    func toggleRepeatMode()
    func toggleShuffleMode()
    func playNext()
    func playPrevious()
    
    func updateQueue()
    func addToQueue(item: MediaItem)
    func play(queuedItem: QueuedItemType)
}

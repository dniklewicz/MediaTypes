//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Foundation

public protocol MediaRenderer: Identifiable
where ID: Codable {
    associatedtype MediaItemType: MediaItem
    
    var name: String { get }
    
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
    
    func play(item: Playable)
    func set(volume: Int)
    func set(mute: Bool)
    func set(playState: PlayState)
    func set(zoneVolume: Int)
    func set(zoneMute: Bool)
    func toggleRepeatMode()
    func toggleShuffleMode()
    func playNext()
    func playPrevious()
}

public enum MediaRenderingGroupMemberRole: String, Codable {
    case leader = "leader"
    case member = "member"
}

public protocol MediaRenderingGroupMember<Renderer>: Codable {
    associatedtype Renderer: MediaRenderer
    var id: Renderer.ID { get }
    var role: MediaRenderingGroupMemberRole { get }
}

public protocol MediaRenderingGroup<Member>: Identifiable {
    associatedtype Renderer: GroupableMediaRenderer
    associatedtype Member: MediaRenderingGroupMember<Renderer>
    
    var name: String { get }
    // All members with leader at first index.
    var members: [Member] { get }
}

public extension MediaRenderingGroup {
    var leaderId: Renderer.ID? { members.first { $0.role == .leader }?.id }
}

public protocol GroupableMediaRenderer: MediaRenderer {
    associatedtype RenderingGroup: MediaRenderingGroup
    where Self.ID == RenderingGroup.Renderer.ID
    
    var group: RenderingGroup? { get }
    var groupPublished: Published<RenderingGroup?> { get }
    var groupPublisher: Published<RenderingGroup?>.Publisher { get }
}

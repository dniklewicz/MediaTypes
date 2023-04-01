//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Foundation

public protocol MediaRenderer: Identifiable
where ID: Codable {
    associatedtype MediaItemType: MediaItem
    
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
    
    var progress: PlaybackProgress? { get }
    var progressPublished: Published<PlaybackProgress?> { get }
    var progressPublisher: Published<PlaybackProgress?>.Publisher { get }
    
    var speakerSettings: [any SpeakerSetting] { get }
    var speakerSettingsPublished: Published<[any SpeakerSetting]> { get }
    var speakerSettingsPublisher: Published<[any SpeakerSetting]>.Publisher { get }
    
    func play(item: Playable) async throws
    func set(volume: Int) async throws
    func set(mute: Bool) async throws
    func set(playState: PlayState) async throws
    func set<T: SpeakerSetting>(value: T.SettingType, for: T) async throws
    func toggleRepeatMode() async throws
    func toggleShuffleMode() async throws
    func playNext() async throws
    func playPrevious() async throws
    func updateState() async throws
    func startUpdates() async throws
    func stopUpdates() async throws
}

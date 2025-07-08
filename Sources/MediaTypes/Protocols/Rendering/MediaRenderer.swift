//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Combine
import Foundation

public protocol MediaRenderer: Identifiable, Equatable {
    associatedtype MediaItemType: MediaItem
	
	var id: String { get }
    var name: String { get }
    var model: String { get }
    var ipAddress: String { get }

    var playState: PlayState { get }
    var playStatePublisher: AnyPublisher<PlayState, Never> { get }
	
	var minVolume: Double { get }
	var maxVolume: Double { get }

    var volume: Int { get }
    var volumePublisher: AnyPublisher<Int, Never> { get }

    var mute: Bool { get }
    var mutePublisher: AnyPublisher<Bool, Never> { get }

    var availableActions: [PlaybackAction] { get }
    var availableActionsPublisher: AnyPublisher<[PlaybackAction], Never> { get }

    var repeatMode: RepeatMode { get }
    var repeatModePublisher: AnyPublisher<RepeatMode, Never> { get }

    var shuffleMode: ShuffleMode { get }
    var shuffleModePublisher: AnyPublisher<ShuffleMode, Never> { get }

    var currentTrack: MediaItemType? { get }
    var currentTrackPublisher: AnyPublisher<MediaItemType?, Never> { get }

    var progress: PlaybackProgress? { get }
    var progressPublisher: AnyPublisher<PlaybackProgress?, Never> { get }

    var speakerSettings: [any SpeakerSetting] { get }
    var speakerSettingsPublisher: AnyPublisher<[any SpeakerSetting], Never> { get }

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

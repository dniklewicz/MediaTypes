//  Copyright © 2021 Dariusz Niklewicz. All rights reserved.

import Foundation

public protocol PlayQueueProviding {
    associatedtype QueuedItemType: QueuedItem
    
    var playQueue: [QueuedItemType] { get }
    var playQueuePublished: Published<[QueuedItemType]> { get }
    var playQueuePublisher: Published<[QueuedItemType]>.Publisher { get }
    
    func updateQueue() async throws
    func addToQueue(item: MediaItem)
    func play(queuedItem: QueuedItemType)
}

public enum PowerState {
    case on, off, standby
}

public protocol PowerStateProviding {
    var powerState: PowerState { get }
    var powerStatePublished: Published<PowerState> { get }
    var powerStatePublisher: Published<PowerState>.Publisher { get }
    
    func set(powerState: PowerState) async
}

public protocol SpeakerSettingType {}
extension String: SpeakerSettingType {}
extension Int: NumericalSpeakerSettingType {}
extension Double: NumericalSpeakerSettingType {}

public protocol SpeakerSetting<SettingType>: Identifiable {
    associatedtype SettingType: SpeakerSettingType
    
    var name: String { get }
    var value: SettingType { get set }
}

public protocol NumericalSpeakerSettingType: SpeakerSettingType, SignedNumeric, Comparable {}
public struct EnumerationSpeakerSetting: SpeakerSetting {
    public var name: String
    public var id: String
    public var value: String
    
    let cases: [String]
}

public protocol NumericalSpeakerSettingProtocol<SettingType>: SpeakerSetting
where SettingType: NumericalSpeakerSettingType {
    var range: ClosedRange<SettingType> { get }
    var step: SettingType { get }
}

public struct IntegerSpeakerSetting: NumericalSpeakerSettingProtocol {
    public var id: String
    public var name: String
    public var value: Int
    public var range: ClosedRange<Int>
    public var step: Int
    
    init(id: String, name: String, value: Int, range: ClosedRange<Int>, step: Int) {
        self.id = id
        self.name = name
        self.value = value
        self.range = range
        self.step = step
    }
}

//public struct SpeakerSetting<T: SpeakerSettingType>: Identifiable {
//    public let id: String
//    public let name: String
//    public let value: T
//}

public protocol MediaRenderer: Identifiable
where ID: Codable {
    associatedtype MediaItemType: MediaItem
    associatedtype SettingType: SpeakerSetting
    
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
    
    var speakerSettings: [SettingType] { get }
    var speakerSettingsPublished: Published<[SettingType]> { get }
    var speakerSettingsPublisher: Published<[SettingType]>.Publisher { get }
    
    func play(item: Playable) async throws
    func set(volume: Int) async throws
    func set(mute: Bool) async throws
    func set(playState: PlayState) async throws
    func set(value: SettingType.SettingType, for: SettingType) async throws
    func toggleRepeatMode() async throws
    func toggleShuffleMode() async throws
    func playNext() async throws
    func playPrevious() async throws
    func updateState() async throws
    func startUpdates() async throws
    func stopUpdates() async throws
}

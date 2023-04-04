//  Created by Dariusz Niklewicz on 23/12/2022.

import Combine
import Foundation

public struct MockGroupMember: MediaRenderingGroupMember {
    public typealias Renderer = MockPlayer

    public var role: MediaRenderingGroupMemberRole
    public var id: MockPlayer.ID
}

public struct MockGroup: MediaRenderingGroup {
    public typealias Renderer = MockGroupMember.Renderer
    public typealias Member = MockGroupMember

    public var name: String
    public var id: Int
    public var members: [MockGroupMember]
}

public struct MockQueuedItem: QueuedItem {
    public var id: NSNumber
    public var title: String
    public var artist: String?
    public var album: String?
    public var artwork: MediaTypes.Artwork?

    public init(id: NSNumber, title: String, artist: String?, album: String?, artwork: Artwork?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}

public struct MockItemType: MediaItem {
    public var thumbnail: Artwork?
    public var displayTitle: String
    public var displaySubtitle: String?
    public var metadata: MediaItemMetadata?
    public var typeString: String?
}

public class MockPlayer: GroupableMediaRenderer, PlayQueueProviding {
    public var name: String
    public var model: String
    public var ipAddress: String = ""

    @Published public var playState: PlayState = .stop
    public var playStatePublished: Published<PlayState> { _playState }
    public var playStatePublisher: Published<PlayState>.Publisher { $playState }

    @Published public var volume: Int = 10
    public var volumePublished: Published<Int> { _volume }
    public var volumePublisher: Published<Int>.Publisher { $volume }

    @Published public var mute: Bool = false
    public var mutePublished: Published<Bool> { _mute }
    public var mutePublisher: Published<Bool>.Publisher { $mute }

    @Published public var zoneVolume: Int = 10
    public var zoneVolumePublished: Published<Int> { _zoneVolume }
    public var zoneVolumePublisher: Published<Int>.Publisher { $zoneVolume }

    @Published public var zoneMute: Bool = false
    public var zoneMutePublished: Published<Bool> { _zoneMute }
    public var zoneMutePublisher: Published<Bool>.Publisher { $zoneMute }

    @Published public var availableActions: [PlaybackAction] = []
    public var availableActionsPublished: Published<[PlaybackAction]> { _availableActions }
    public var availableActionsPublisher: Published<[PlaybackAction]>.Publisher { $availableActions }

    @Published public var repeatMode: RepeatMode = .off
    public var repeatModePublished: Published<RepeatMode> { _repeatMode }
    public var repeatModePublisher: Published<RepeatMode>.Publisher { $repeatMode }

    @Published public var shuffleMode: ShuffleMode = .off
    public var shuffleModePublished: Published<ShuffleMode> { _shuffleMode }
    public var shuffleModePublisher: Published<ShuffleMode>.Publisher { $shuffleMode }

    @Published public var currentTrack: MockItemType?
    public var currentTrackPublished: Published<MockItemType?> { _currentTrack }
    public var currentTrackPublisher: Published<MockItemType?>.Publisher { $currentTrack }

    @Published public var progress: PlaybackProgress?
    public var progressPublished: Published<PlaybackProgress?> { _progress }
    public var progressPublisher: Published<PlaybackProgress?>.Publisher { $progress}

    @Published public var speakerSettings: [any SpeakerSetting] = {
        [
            DoubleSpeakerSetting(id: "bass", name: "Bass", value: 5, range: (0...10), step: 1),
            DoubleSpeakerSetting(id: "mid", name: "Mid", value: 5, range: (0...10), step: 1),
            DoubleSpeakerSetting(id: "treble", name: "Treble", value: 5, range: (0...10), step: 1),
            BooleanSpeakerSetting(id: "enhancer", name: "Enhancer", value: false),
            EnumerationSpeakerSetting(name: "Preset", id: "preset", value: "manual", cases: ["manual", "auto"])
        ]
    }()
    public var speakerSettingsPublished: Published<[any SpeakerSetting]> { _speakerSettings }
    public var speakerSettingsPublisher: Published<[any SpeakerSetting]>.Publisher { $speakerSettings }

    public func play(item: Playable) {}
    public func set(volume: Int) {}
    public func set(mute: Bool) {}
    public func set(playState: PlayState) {}
    public func set(zoneVolume: Int) {}
    public func set(zoneMute: Bool) {}
    public func set(value: Int, for: DoubleSpeakerSetting) async throws {}
    public func set<T>(value: T.SettingType, for: T) async throws where T: SpeakerSetting {}
    public func toggleRepeatMode() {}
    public func toggleShuffleMode() {}
    public func playNext() {}
    public func playPrevious() {}
    public func updateQueue() {}
    public func play(queuedItem: MockQueuedItem) {}

    public typealias MediaItemType = MockItemType
    public typealias QueuedItemType = MockQueuedItem

    public func createGroup(withMembers members: [ID]) {}
    public func addToGroup(member: ID) {}
    public func leaveGroup() {}
    public func addToQueue(item: MediaItem) {}
    public func updateState() {}
    public func startUpdates() {}
    public func stopUpdates() {}

    public let id: Int
    @Published public var group: MockGroup?
    public var groupPublished: Published<MockGroup?> { _group }
    public var groupPublisher: Published<MockGroup?>.Publisher { $group }

    @Published public var playQueue: [MockQueuedItem] = []
    public var playQueuePublished: Published<[MockQueuedItem]> { _playQueue }
    public var playQueuePublisher: Published<[MockQueuedItem]>.Publisher { $playQueue }

    public init(
        id: Int,
        name: String,
        model: String
    ) {
        self.id = id
        self.name = name
        self.model = model
    }
}

public class MockManager: GroupableMediaRenderersManager {
    public typealias Renderer = MockPlayer

    @Published public var renderers: [MockPlayer]
    public var renderersPublished: Published<[MockPlayer]> { _renderers }
    public var renderersPublisher: Published<[MockPlayer]>.Publisher { $renderers }

    @Published public var groups: [MockGroup]
    public var groupsPublished: Published<[MockGroup]> { _groups }
    public var groupsPublisher: Published<[MockGroup]>.Publisher { $groups }

    public init(renderers: [MockPlayer] = [], groups: [MockGroup] = []) {
        self.renderers = renderers
        self.groups = groups
    }

    public func process(deviceDescription: String, ipAddress: String, port: Int) -> Bool { false }
}

public class PowerableMockPlayer: MockPlayer, PowerStateProviding {
    @Published public var powerState: PowerState
    public var powerStatePublisher: Published<PowerState>.Publisher { $powerState }
    public func set(powerState: PowerState) async throws {}

    public init(
        powerState: PowerState,
        id: Int,
        name: String,
        model: String
    ) {
        self.powerState = powerState
        super.init(id: id, name: name, model: model)
    }
}

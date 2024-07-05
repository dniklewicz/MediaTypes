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
	public static func == (lhs: MockPlayer, rhs: MockPlayer) -> Bool {
		lhs.name == rhs.name
	}
	
    public var name: String
    public var model: String
    public var ipAddress: String = ""

    @Published public var playState: PlayState = .stop
    public var playStatePublisher: Published<PlayState>.Publisher { $playState }

    @Published public var volume: Int = 10
    public var volumePublisher: Published<Int>.Publisher { $volume }

    @Published public var mute: Bool = false
    public var mutePublisher: Published<Bool>.Publisher { $mute }

    @Published public var zoneVolume: Int = 10
    public var zoneVolumePublisher: Published<Int>.Publisher { $zoneVolume }

    @Published public var zoneMute: Bool = false
    public var zoneMutePublisher: Published<Bool>.Publisher { $zoneMute }

    @Published public var availableActions: [PlaybackAction] = []
    public var availableActionsPublisher: Published<[PlaybackAction]>.Publisher { $availableActions }

    @Published public var repeatMode: RepeatMode = .off
    public var repeatModePublisher: Published<RepeatMode>.Publisher { $repeatMode }

    @Published public var shuffleMode: ShuffleMode = .off
    public var shuffleModePublisher: Published<ShuffleMode>.Publisher { $shuffleMode }

    @Published public var currentTrack: MockItemType?
    public var currentTrackPublisher: Published<MockItemType?>.Publisher { $currentTrack }

    @Published public var progress: PlaybackProgress?
    public var progressPublisher: Published<PlaybackProgress?>.Publisher { $progress}
	
	public var minVolume: Double = 0
	public var maxVolume: Double = 60

    @Published public var speakerSettings: [any SpeakerSetting] = {
        [
            DoubleSpeakerSetting(id: "bass", name: "Bass", value: 5, range: (0...10), step: 1),
            DoubleSpeakerSetting(id: "mid", name: "Mid", value: 5, range: (0...10), step: 1),
            DoubleSpeakerSetting(id: "treble", name: "Treble", value: 5, range: (0...10), step: 1),
            BooleanSpeakerSetting(id: "enhancer", name: "Enhancer", value: false),
            EnumerationSpeakerSetting(name: "Preset", id: "preset", value: "manual", cases: ["manual", "auto"])
        ]
    }()
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
	public func addToQueue(item: any MediaItem) {}
    public func updateState() {}
    public func startUpdates() {}
    public func stopUpdates() {}

	public var id: String
    @Published public var group: MockGroup?
    public var groupPublisher: Published<MockGroup?>.Publisher { $group }

    @Published public var playQueue: [MockQueuedItem] = []
    public var playQueuePublisher: Published<[MockQueuedItem]>.Publisher { $playQueue }

    public init(
        id: ID,
        name: String,
        model: String,
		mediaItem: MockItemType? = nil
    ) {
        self.id = id
        self.name = name
        self.model = model
		if mediaItem != nil {
			self.playState = .play
		}
		self.currentTrack = mediaItem
    }
}

extension MockItemType {
	static let kaczorek: MockItemType = .init(thumbnail: .image(.init("kaczorek", bundle: .module)), displayTitle: "", metadata: .init(title: "Skatepark", artist: "The Duckilings", album: nil))
	static let bysiek: MockItemType = .init(thumbnail: .image(.init("bysiek", bundle: .module)), displayTitle: "", metadata: .init(title: "Life is a journey", artist: "Darqué", album: nil))
}

public class MockManager: GroupableMediaRenderersManager {
    public typealias Renderer = MockPlayer

    @Published public var renderers: [MockPlayer]
    public var renderersPublisher: Published<[MockPlayer]>.Publisher { $renderers }

    @Published public var groups: [MockGroup]
    public var groupsPublisher: Published<[MockGroup]>.Publisher { $groups }

    public init(renderers: [MockPlayer], groups: [MockGroup] = []) {
        self.renderers = renderers
        self.groups = groups
    }
	
	public init() {
		self.renderers = [
			PowerableMockPlayer(id: "1", name: "Living Room", model: "Speaker 3", mediaItem: .bysiek),
			PowerableMockPlayer(id: "2", name: "Office", model: "Speaker 5"),
			PowerableMockPlayer(id: "3", name: "Bedroom", model: "Speaker 7", mediaItem: .kaczorek)
		]
		
		self.groups = [
			.init(name: "Living Room + Office", id: 1, members: [
				.init(role: .leader, id: "1"),
				.init(role: .member, id: "2")
			])
		]
		
		// Assign groups to renderers
		for group in groups {
			for renderer in renderers {
				if group.members.contains(where: { $0.id == renderer.id }) {
					renderer.group = group
				}
			}
		}
	}

    public func process(deviceDescription: String, ipAddress: String, port: Int) -> Bool { false }
}

public class PowerableMockPlayer: MockPlayer, PowerStateProviding {
    @Published public var powerState: PowerState
    public var powerStatePublisher: Published<PowerState>.Publisher { $powerState }
    public func set(powerState: PowerState) async throws {}

    public init(
		powerState: PowerState = .on,
        id: String,
        name: String,
        model: String,
		mediaItem: MockItemType? = nil
    ) {
        self.powerState = powerState
		super.init(id: id, name: name, model: model, mediaItem: mediaItem)
    }
}

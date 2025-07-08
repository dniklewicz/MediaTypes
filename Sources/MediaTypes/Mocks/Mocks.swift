//  Created by Dariusz Niklewicz on 23/12/2022.

import Combine
import Foundation

public struct MockGroupMember: MediaRenderingGroupMember {
	public var name: String
	
    public typealias Renderer = MockPlayer

    public var role: MediaRenderingGroupMemberRole
    public var id: MockPlayer.ID
	
	public init(role: MediaRenderingGroupMemberRole, id: MockPlayer.ID, name: String = "Test member") {
		self.role = role
		self.id = id
		self.name = name
	}
}

public struct MockGroup: MediaRenderingGroup {
    public typealias Renderer = MockGroupMember.Renderer
    public typealias Member = MockGroupMember

    public var name: String
    public var id: Int
    public var members: [MockGroupMember]
	
	public init(name: String, id: Int, members: [MockGroupMember]) {
		self.name = name
		self.id = id
		self.members = members
	}
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
	
	public init(
		thumbnail: Artwork? = nil,
		displayTitle: String,
		displaySubtitle: String? = nil,
		metadata: MediaItemMetadata? = nil,
		typeString: String? = nil
	) {
		self.thumbnail = thumbnail
		self.displayTitle = displayTitle
		self.displaySubtitle = displaySubtitle
		self.metadata = metadata
		self.typeString = typeString
	}
}

public class MockPlayer: GroupableMediaRenderer, PlayQueueProviding {
	public static func == (lhs: MockPlayer, rhs: MockPlayer) -> Bool {
		lhs.name == rhs.name
	}
	
    public var name: String
    public var model: String
    public var ipAddress: String = ""

    @Published public var playState: PlayState = .stop
    public var playStatePublisher: AnyPublisher<PlayState, Never> { $playState.eraseToAnyPublisher() }

    @Published public var volume: Int = 10
    public var volumePublisher: AnyPublisher<Int, Never> { $volume.eraseToAnyPublisher() }

    @Published public var mute: Bool = false
    public var mutePublisher: AnyPublisher<Bool, Never> { $mute.eraseToAnyPublisher() }

    @Published public var zoneVolume: Int = 10
    public var zoneVolumePublisher: AnyPublisher<Int, Never> { $zoneVolume.eraseToAnyPublisher() }

    @Published public var zoneMute: Bool = false
    public var zoneMutePublisher: AnyPublisher<Bool, Never> { $zoneMute.eraseToAnyPublisher() }

    @Published public var availableActions: [PlaybackAction] = []
    public var availableActionsPublisher: AnyPublisher<[PlaybackAction], Never> { $availableActions.eraseToAnyPublisher() }

    @Published public var repeatMode: RepeatMode = .off
    public var repeatModePublisher: AnyPublisher<RepeatMode, Never> { $repeatMode.eraseToAnyPublisher() }

    @Published public var shuffleMode: ShuffleMode = .off
    public var shuffleModePublisher: AnyPublisher<ShuffleMode, Never> { $shuffleMode.eraseToAnyPublisher() }

    @Published public var currentTrack: MockItemType?
    public var currentTrackPublisher: AnyPublisher<MockItemType?, Never> { $currentTrack.eraseToAnyPublisher() }

    @Published public var progress: PlaybackProgress?
    public var progressPublisher: AnyPublisher<PlaybackProgress?, Never> { $progress.eraseToAnyPublisher() }
	
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
    public var speakerSettingsPublisher: AnyPublisher<[any SpeakerSetting], Never> { $speakerSettings.eraseToAnyPublisher() }

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
	public func removeFromQueue(items: [MockQueuedItem]) async throws {}
    public func play(queuedItem: MockQueuedItem) {}
	public func clearQueue() async throws {}
	public func moveQueue(items: [MockQueuedItem], insertAt: Int) async throws {}

    public typealias MediaItemType = MockItemType
    public typealias QueuedItemType = MockQueuedItem

    public func createGroup(withMembers members: [ID]) {}
    public func addToGroup(member: ID) {}
    public func leaveGroup() {}
	public func addToQueue(item: any MediaItem, option: AddToQueueOption) async throws {}
    public func updateState() {}
    public func startUpdates() {}
    public func stopUpdates() {}

	public var id: String
    @Published public var group: MockGroup?
    public var groupPublisher: AnyPublisher<MockGroup?, Never> { $group.eraseToAnyPublisher() }

    @Published public var playQueue: [MockQueuedItem] = []
    public var playQueuePublisher: AnyPublisher<[MockQueuedItem], Never> { $playQueue.eraseToAnyPublisher() }

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
	public static func == (lhs: MockManager, rhs: MockManager) -> Bool {
		lhs === rhs
	}
	
    public typealias Renderer = MockPlayer

    @Published public var renderers: [MockPlayer]
    public var renderersPublisher: AnyPublisher<[MockPlayer], Never> { $renderers.eraseToAnyPublisher() }

    @Published public var groups: [MockGroup]
    public var groupsPublisher: AnyPublisher<[MockGroup], Never> { $groups.eraseToAnyPublisher() }

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
    public var powerStatePublisher: AnyPublisher<PowerState, Never> { $powerState.eraseToAnyPublisher() }
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

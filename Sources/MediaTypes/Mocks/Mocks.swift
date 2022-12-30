//  Created by Dariusz Niklewicz on 23/12/2022.

import Foundation

struct MockGroupMember: MediaRenderingGroupMember {
    typealias Renderer = MockPlayer
    
    var role: MediaRenderingGroupMemberRole
    var id: MockPlayer.ID
}

struct MockGroup: MediaRenderingGroup {
    typealias Renderer = MockGroupMember.Renderer
    typealias Member = MockGroupMember
    
    var name: String
    var id: Int
    var members: [MockGroupMember]
}

struct MockQueuedItem: QueuedItem {
    var id: NSNumber
    var title: String
    var artist: String?
    var album: String?
    var artwork: MediaTypes.Artwork?
    
    init(id: NSNumber, title: String, artist: String?, album: String?, artwork: Artwork?) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}

struct MockItemType: MediaItem {
    var thumbnail: Artwork?
    var displayTitle: String
    var displaySubtitle: String?
    var metadata: MediaItemMetadata?
    var typeString: String?
}

class MockPlayer: GroupableMediaRenderer {
    var name: String
    var model: String
    var ipAddress: String = ""
    
    @Published var playState: PlayState = .stop
    var playStatePublished: Published<PlayState> { _playState }
    var playStatePublisher: Published<PlayState>.Publisher { $playState }
    
    @Published var volume: Int = 10
    var volumePublished: Published<Int> { _volume }
    var volumePublisher: Published<Int>.Publisher { $volume }
    
    @Published var mute: Bool = false
    var mutePublished: Published<Bool> { _mute }
    var mutePublisher: Published<Bool>.Publisher { $mute }
    
    @Published var zoneVolume: Int = 10
    var zoneVolumePublished: Published<Int> { _zoneVolume }
    var zoneVolumePublisher: Published<Int>.Publisher { $zoneVolume }
    
    @Published var zoneMute: Bool = false
    var zoneMutePublished: Published<Bool> { _zoneMute }
    var zoneMutePublisher: Published<Bool>.Publisher { $zoneMute }
    
    @Published var availableActions: [PlaybackAction] = []
    var availableActionsPublished: Published<[PlaybackAction]> { _availableActions }
    var availableActionsPublisher: Published<[PlaybackAction]>.Publisher { $availableActions }
    
    @Published var repeatMode: RepeatMode = .off
    var repeatModePublished: Published<RepeatMode> { _repeatMode }
    var repeatModePublisher: Published<RepeatMode>.Publisher { $repeatMode }
    
    @Published var shuffleMode: ShuffleMode = .off
    var shuffleModePublished: Published<ShuffleMode> { _shuffleMode }
    var shuffleModePublisher: Published<ShuffleMode>.Publisher { $shuffleMode }
    
    @Published var currentTrack: MockItemType?
    var currentTrackPublished: Published<MockItemType?> { _currentTrack }
    var currentTrackPublisher: Published<MockItemType?>.Publisher { $currentTrack }
    
    @Published var progress: PlaybackProgress?
    var progressPublished: Published<PlaybackProgress?> { _progress }
    var progressPublisher: Published<PlaybackProgress?>.Publisher { $progress}
    
    @Published var treble: Int = 5
    var treblePublished: Published<Int> { _treble }
    var treblePublisher: Published<Int>.Publisher { $treble }
    
    @Published var bass: Int = 5
    var bassPublished: Published<Int> { _bass }
    var bassPublisher: Published<Int>.Publisher { $bass }

    func play(item: Playable) {}
    func set(volume: Int) {}
    func set(mute: Bool) {}
    func set(playState: PlayState) {}
    func set(zoneVolume: Int) {}
    func set(zoneMute: Bool) {}
    func set(treble: Int) {}
    func set(bass: Int) {}
    func toggleRepeatMode() {}
    func toggleShuffleMode() {}
    func playNext() {}
    func playPrevious() {}
    func updateQueue() {}
    func play(queuedItem: MockQueuedItem) {}
    
    typealias MediaItemType = MockItemType
    typealias QueuedItemType = MockQueuedItem
    
    func createGroup(withMembers members: [ID]) {}
    func addToGroup(member: ID) {}
    func leaveGroup() {}
    func addToQueue(item: MediaItem) {}
    
    let id: Int
    @Published var group: MockGroup?
    var groupPublished: Published<MockGroup?> { _group }
    var groupPublisher: Published<MockGroup?>.Publisher { $group }
    
    @Published var playQueue: [MockQueuedItem] = []
    var playQueuePublished: Published<[MockQueuedItem]> { _playQueue }
    var playQueuePublisher: Published<[MockQueuedItem]>.Publisher { $playQueue }
    
    init(
        id: Int,
        name: String,
        model: String
    ) {
        self.id = id
        self.name = name
        self.model = model
    }
}

class MockManager: GroupableMediaRenderersManager {
    typealias Renderer = MockPlayer

    @Published var renderers: [MockPlayer] = []
    var renderersPublished: Published<[MockPlayer]> { _renderers }
    var renderersPublisher: Published<[MockPlayer]>.Publisher { $renderers }
    
    @Published var groups: [MockGroup] = []
    var groupsPublished: Published<[MockGroup]> { _groups }
    var groupsPublisher: Published<[MockGroup]>.Publisher { $groups }
}

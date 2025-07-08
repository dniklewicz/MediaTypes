import XCTest
import Combine
@testable import MediaTypes

final class ProtocolComplianceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - MediaItem Protocol Compliance
    
    func testMediaItemProtocolCompliance() {
        let mockItem = MockItemType(
            thumbnail: .url(URL(string: "https://example.com/image.jpg")!),
            displayTitle: "Test Item",
            displaySubtitle: "Test Subtitle",
            metadata: MediaItemMetadata(title: "Test", artist: "Artist", album: "Album"),
            typeString: "song"
        )
        
        // Test required properties
        XCTAssertNotNil(mockItem.thumbnail)
        XCTAssertEqual(mockItem.displayTitle, "Test Item")
        XCTAssertEqual(mockItem.displaySubtitle, "Test Subtitle")
        XCTAssertNotNil(mockItem.metadata)
        XCTAssertEqual(mockItem.typeString, "song")
        
        // Test default implementations
        XCTAssertTrue(mockItem.isAvailable)
        XCTAssertFalse(mockItem.isQueueable)
        XCTAssertEqual(mockItem.id, "Test Item")
        
        // Test Identifiable compliance
        let id: String = mockItem.id
        XCTAssertEqual(id, "Test Item")
        
        // Test Equatable compliance
        let anotherItem = MockItemType(
            thumbnail: .url(URL(string: "https://example.com/image.jpg")!),
            displayTitle: "Test Item",
            displaySubtitle: "Test Subtitle",
            metadata: MediaItemMetadata(title: "Test", artist: "Artist", album: "Album"),
            typeString: "song"
        )
        XCTAssertEqual(mockItem, anotherItem)
    }
    
    // MARK: - MediaItemsContainer Protocol Compliance
    
    func testMediaItemsContainerProtocolCompliance() async throws {
        let items: [any MediaItem] = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2")
        ]
        
        let container = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Container",
            displaySubtitle: "Test Subtitle",
            thumbnail: nil,
            items: items
        )
        
        // Test MediaItem conformance
        XCTAssertEqual(container.displayTitle, "Test Container")
        XCTAssertEqual(container.displaySubtitle, "Test Subtitle")
        XCTAssertNil(container.thumbnail)
        XCTAssertTrue(container.isAvailable)
        XCTAssertEqual(container.id, "Test Container")
        
        // Test MediaItemsContainer specific properties
        XCTAssertEqual(container.searchCriteria.count, 0)
        XCTAssertNil(container.isActiveContainer)
        XCTAssertFalse(container.supportsItemsHiding)
        XCTAssertFalse(container.searchable)
        
        // Test async methods
        let (retrievedItems, count) = try await container.getItems(range: 0...1)
        XCTAssertEqual(retrievedItems.count, 2)
        XCTAssertEqual(count, 2)
        
        let searchResults = try await container.search(
            for: "test",
            using: NotSearchableCriteria(),
            range: 0...10,
            isFirstSearch: true
        )
        XCTAssertEqual(searchResults.count, 0)
        
        // Test search cancellation
        container.searchWillCancel() // Should not crash
    }
    
    // MARK: - PlayableMediaItemsContainer Protocol Compliance
    
    func testPlayableMediaItemsContainerProtocolCompliance() async throws {
        let items: [any MediaItem] = [
            MockItemType(displayTitle: "Playable Item 1"),
            MockItemType(displayTitle: "Playable Item 2")
        ]
        
        let container = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Playable Container",
            thumbnail: nil,
            items: items
        )
        
        // Test MediaItemsContainer conformance
        XCTAssertEqual(container.displayTitle, "Playable Container")
        XCTAssertTrue(container.isAvailable)
        XCTAssertEqual(container.searchCriteria.count, 0)
        
        // Test async methods
        let (retrievedItems, count) = try await container.getItems(range: 0...1)
        XCTAssertEqual(retrievedItems.count, 2)
        XCTAssertEqual(count, 2)
        
        // Test Playable conformance (marker protocol)
        // PlayableMediaItemsContainer should be playable
        // Note: Protocol conformance is verified at compile time
    }
    
    // MARK: - MediaRenderer Protocol Compliance
    
    func testMediaRendererProtocolCompliance() async throws {
        let mockItem = MockItemType(displayTitle: "Test Track")
        let renderer = MockPlayer(
            id: "test-renderer",
            name: "Test Renderer",
            model: "Test Model",
            mediaItem: mockItem
        )
        
        // Test required properties
        XCTAssertEqual(renderer.id, "test-renderer")
        XCTAssertEqual(renderer.name, "Test Renderer")
        XCTAssertEqual(renderer.model, "Test Model")
        XCTAssertEqual(renderer.ipAddress, "")
        XCTAssertEqual(renderer.playState, .play)
        XCTAssertEqual(renderer.volume, 10)
        XCTAssertFalse(renderer.mute)
        XCTAssertEqual(renderer.minVolume, 0)
        XCTAssertEqual(renderer.maxVolume, 60)
        XCTAssertNotNil(renderer.currentTrack)
        XCTAssertEqual(renderer.currentTrack?.displayTitle, "Test Track")
        
        // Test publishers
        let playStateExpectation = XCTestExpectation(description: "Play state published")
        renderer.playStatePublisher
            .sink { state in
                XCTAssertEqual(state, .play)
                playStateExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [playStateExpectation], timeout: 1.0)
        
        // Test async methods (should not throw)
        renderer.play(item: mockItem)
        renderer.set(volume: 50)
        renderer.set(mute: true)
        renderer.set(playState: .pause)
        renderer.toggleRepeatMode()
        renderer.toggleShuffleMode()
        renderer.playNext()
        renderer.playPrevious()
        renderer.updateState()
        renderer.startUpdates()
        renderer.stopUpdates()
        
        // Test Identifiable compliance
        let id: String = renderer.id
        XCTAssertEqual(id, "test-renderer")
        
        // Test Equatable compliance
        let anotherRenderer = MockPlayer(id: "other", name: "Test Renderer", model: "Model")
        XCTAssertEqual(renderer, anotherRenderer) // Same name
    }
    
    // MARK: - GroupableMediaRenderer Protocol Compliance
    
    func testGroupableMediaRendererProtocolCompliance() async throws {
        let renderer = MockPlayer(
            id: "groupable-renderer",
            name: "Groupable Renderer",
            model: "Test Model"
        )
        
        // Test GroupableMediaRenderer specific properties
        XCTAssertEqual(renderer.zoneVolume, 10)
        XCTAssertFalse(renderer.zoneMute)
        XCTAssertNil(renderer.group)
        
        // Test zone publishers
        let zoneVolumeExpectation = XCTestExpectation(description: "Zone volume published")
        renderer.zoneVolumePublisher
            .sink { volume in
                XCTAssertEqual(volume, 10)
                zoneVolumeExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [zoneVolumeExpectation], timeout: 1.0)
        
        // Test group management async methods
        renderer.createGroup(withMembers: ["member1", "member2"])
        renderer.addToGroup(member: "member3")
        renderer.leaveGroup()
        renderer.set(zoneVolume: 30)
        renderer.set(zoneMute: true)
        
        // Test group assignment
        let group = MockGroup(
            name: "Test Group",
            id: 1,
            members: [
                MockGroupMember(role: .leader, id: "groupable-renderer", name: "Groupable Renderer")
            ]
        )
        renderer.group = group
        
        XCTAssertEqual(renderer.group?.name, "Test Group")
        XCTAssertEqual(renderer.group?.leaderId, "groupable-renderer")
    }
    
    // MARK: - PlayQueueProviding Protocol Compliance
    
    func testPlayQueueProvidingProtocolCompliance() async throws {
        let renderer = MockPlayer(
            id: "queue-renderer",
            name: "Queue Renderer",
            model: "Test Model"
        )
        
        // Test initial empty queue
        XCTAssertEqual(renderer.playQueue.count, 0)
        
        // Test queue publisher
        let queueExpectation = XCTestExpectation(description: "Queue published")
        renderer.playQueuePublisher
            .sink { queue in
                XCTAssertEqual(queue.count, 0)
                queueExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [queueExpectation], timeout: 1.0)
        
        // Test queue management methods
        let mockItem = MockItemType(displayTitle: "Test Track")
        try await renderer.addToQueue(item: mockItem, option: .playNow)
        renderer.updateQueue()
        
        // Test queue manipulation
        let queuedItem = MockQueuedItem(
            id: NSNumber(value: 1),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: nil
        )
        
        renderer.play(queuedItem: queuedItem)
        try await renderer.removeFromQueue(items: [queuedItem])
        try await renderer.clearQueue()
        try await renderer.moveQueue(items: [queuedItem], insertAt: 0)
    }
    
    // MARK: - MediaRenderersManager Protocol Compliance
    
    func testMediaRenderersManagerProtocolCompliance() async {
        let renderer1 = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let renderer2 = MockPlayer(id: "2", name: "Player 2", model: "Model 2")
        
        let manager = MockManager(renderers: [renderer1, renderer2])
        
        // Test renderers property
        XCTAssertEqual(manager.renderers.count, 2)
        XCTAssertTrue(manager.renderers.contains(renderer1))
        XCTAssertTrue(manager.renderers.contains(renderer2))
        
        // Test renderer lookup methods
        XCTAssertEqual(manager.renderer(withName: "Player 1"), renderer1)
        XCTAssertEqual(manager.renderer(withName: "Player 2"), renderer2)
        XCTAssertNil(manager.renderer(withName: "Non-existent"))
        
        XCTAssertEqual(manager.renderer(withId: "1"), renderer1)
        XCTAssertEqual(manager.renderer(withId: "2"), renderer2)
        XCTAssertNil(manager.renderer(withId: "non-existent"))
        
        // Test publishers
        let renderersExpectation = XCTestExpectation(description: "Renderers published")
        manager.renderersPublisher
            .sink { renderers in
                XCTAssertEqual(renderers.count, 2)
                renderersExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [renderersExpectation], timeout: 1.0)
        
        // Test Equatable compliance
        let anotherManager = MockManager(renderers: [renderer1, renderer2])
        XCTAssertNotEqual(manager, anotherManager) // Reference equality
    }
    
    // MARK: - GroupableMediaRenderersManager Protocol Compliance
    
    func testGroupableMediaRenderersManagerProtocolCompliance() async {
        let renderer1 = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let renderer2 = MockPlayer(id: "2", name: "Player 2", model: "Model 2")
        
        let group = MockGroup(
            name: "Test Group",
            id: 1,
            members: [
                MockGroupMember(role: .leader, id: "1", name: "Player 1"),
                MockGroupMember(role: .member, id: "2", name: "Player 2")
            ]
        )
        
        let manager = MockManager(renderers: [renderer1, renderer2], groups: [group])
        
        // Test groups property
        XCTAssertEqual(manager.groups.count, 1)
        XCTAssertEqual(manager.groups.first?.name, "Test Group")
        
        // Test groups publisher
        let groupsExpectation = XCTestExpectation(description: "Groups published")
        manager.groupsPublisher
            .sink { groups in
                XCTAssertEqual(groups.count, 1)
                XCTAssertEqual(groups.first?.name, "Test Group")
                groupsExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [groupsExpectation], timeout: 1.0)
    }
    
    // MARK: - QueuedItem Protocol Compliance
    
    func testQueuedItemProtocolCompliance() {
        let artwork = Artwork.url(URL(string: "https://example.com/artwork.jpg")!)
        let queuedItem = MockQueuedItem(
            id: NSNumber(value: 42),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        
        // Test required properties
        XCTAssertEqual(queuedItem.id, NSNumber(value: 42))
        XCTAssertEqual(queuedItem.title, "Test Track")
        XCTAssertEqual(queuedItem.artist, "Test Artist")
        XCTAssertEqual(queuedItem.album, "Test Album")
        XCTAssertEqual(queuedItem.artwork, artwork)
        
        // Test Identifiable compliance
        let id: NSNumber = queuedItem.id
        XCTAssertEqual(id, NSNumber(value: 42))
        
        // Test Equatable compliance
        let anotherQueuedItem = MockQueuedItem(
            id: NSNumber(value: 42),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        XCTAssertEqual(queuedItem, anotherQueuedItem)
    }
    
    // MARK: - SpeakerSetting Protocol Compliance
    
    func testSpeakerSettingProtocolCompliance() {
        // Test DoubleSpeakerSetting
        let doubleSetting = DoubleSpeakerSetting(
            id: "test-double",
            name: "Test Double",
            value: 5.0,
            range: 0.0...10.0,
            step: 0.5
        )
        
        XCTAssertEqual(doubleSetting.id, "test-double")
        XCTAssertEqual(doubleSetting.name, "Test Double")
        XCTAssertEqual(doubleSetting.value, 5.0)
        // Protocol conformance is verified at compile time
        
        // Test BooleanSpeakerSetting
        let boolSetting = BooleanSpeakerSetting(
            id: "test-bool",
            name: "Test Boolean",
            value: true
        )
        
        XCTAssertEqual(boolSetting.id, "test-bool")
        XCTAssertEqual(boolSetting.name, "Test Boolean")
        XCTAssertTrue(boolSetting.value)
        // Protocol conformance is verified at compile time
        
        // Test EnumerationSpeakerSetting
        let enumSetting = EnumerationSpeakerSetting(
            name: "Test Enum",
            id: "test-enum",
            value: "option1",
            cases: ["option1", "option2"]
        )
        
        XCTAssertEqual(enumSetting.id, "test-enum")
        XCTAssertEqual(enumSetting.name, "Test Enum")
        XCTAssertEqual(enumSetting.value, "option1")
        // Protocol conformance is verified at compile time
    }
    
    // MARK: - Integration Tests
    
    func testFullIntegration() async throws {
        // Create a complete system
        let mockItem1 = MockItemType(displayTitle: "Track 1")
        let mockItem2 = MockItemType(displayTitle: "Track 2")
        
        let collection = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: [mockItem1, mockItem2]
        )
        
        let player = MockPlayer(
            id: "integration-player",
            name: "Integration Player",
            model: "Test Model",
            mediaItem: mockItem1
        )
        
        let manager = MockManager(renderers: [player])
        
        // Test that everything works together
        XCTAssertEqual(manager.renderers.count, 1)
        XCTAssertEqual(manager.renderer(withId: "integration-player"), player)
        
        let (items, count) = try await collection.getItems(range: 0...1)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(count, 2)
        
        XCTAssertEqual(player.currentTrack?.displayTitle, "Track 1")
        XCTAssertEqual(player.playState, .play)
        
        // Test playing from collection
        player.play(item: collection)
        
        // Test queue management
        try await player.addToQueue(item: mockItem2, option: .addToEnd)
        
        XCTAssertTrue(true, "Full integration test completed successfully")
    }
} 

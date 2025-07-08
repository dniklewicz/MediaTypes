import XCTest
import Combine
@testable import MediaTypes

final class MockObjectsTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - MockPlayer Tests
    
    func testMockPlayerInitialization() {
        let player = MockPlayer(
            id: "test-player-1",
            name: "Test Player",
            model: "Test Model"
        )
        
        XCTAssertEqual(player.id, "test-player-1")
        XCTAssertEqual(player.name, "Test Player")
        XCTAssertEqual(player.model, "Test Model")
        XCTAssertEqual(player.playState, .stop)
        XCTAssertEqual(player.volume, 10)
        XCTAssertFalse(player.mute)
        XCTAssertEqual(player.zoneVolume, 10)
        XCTAssertFalse(player.zoneMute)
        XCTAssertNil(player.currentTrack)
        XCTAssertNil(player.progress)
        XCTAssertNil(player.group)
        XCTAssertEqual(player.playQueue.count, 0)
        XCTAssertEqual(player.minVolume, 0)
        XCTAssertEqual(player.maxVolume, 60)
    }
    
    func testMockPlayerInitializationWithMediaItem() {
        let mediaItem = MockItemType(displayTitle: "Test Track")
        let player = MockPlayer(
            id: "test-player-2",
            name: "Test Player 2",
            model: "Test Model 2",
            mediaItem: mediaItem
        )
        
        XCTAssertEqual(player.playState, .play)
        XCTAssertEqual(player.currentTrack?.displayTitle, "Test Track")
    }
    
    func testMockPlayerEquality() {
        let player1 = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let player2 = MockPlayer(id: "2", name: "Player 1", model: "Model 2")
        let player3 = MockPlayer(id: "3", name: "Player 2", model: "Model 1")
        
        XCTAssertEqual(player1, player2) // Same name
        XCTAssertNotEqual(player1, player3) // Different name
    }
    
    func testMockPlayerPublishers() async {
        let player = MockPlayer(id: "test", name: "Test Player", model: "Model")
        
        let playStateExpectation = XCTestExpectation(description: "Play state published")
        let volumeExpectation = XCTestExpectation(description: "Volume published")
        let muteExpectation = XCTestExpectation(description: "Mute published")
        
        player.playStatePublisher
            .sink { state in
                XCTAssertEqual(state, .stop)
                playStateExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        player.volumePublisher
            .sink { volume in
                XCTAssertEqual(volume, 10)
                volumeExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        player.mutePublisher
            .sink { mute in
                XCTAssertFalse(mute)
                muteExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [playStateExpectation, volumeExpectation, muteExpectation], timeout: 1.0)
    }
    
    func testMockPlayerSpeakerSettings() {
        let player = MockPlayer(id: "test", name: "Test Player", model: "Model")
        
        XCTAssertEqual(player.speakerSettings.count, 5)
        
        let bassSettings = player.speakerSettings.first { $0.id == "bass" }
        XCTAssertNotNil(bassSettings)
        XCTAssertEqual(bassSettings?.name, "Bass")
        
        let enhancerSettings = player.speakerSettings.first { $0.id == "enhancer" }
        XCTAssertNotNil(enhancerSettings)
        XCTAssertEqual(enhancerSettings?.name, "Enhancer")
    }
    
    func testMockPlayerPlayQueuePublisher() async {
        let player = MockPlayer(id: "test", name: "Test Player", model: "Model")
        
        let expectation = XCTestExpectation(description: "Play queue published")
        
        player.playQueuePublisher
            .sink { queue in
                XCTAssertEqual(queue.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    // MARK: - MockItemType Tests
    
    func testMockItemTypePresets() {
        let kaczorck = MockItemType.kaczorek
        let bysiek = MockItemType.bysiek
        
        XCTAssertEqual(kaczorck.metadata?.title, "Skatepark")
        XCTAssertEqual(kaczorck.metadata?.artist, "The Duckilings")
        XCTAssertNil(kaczorck.metadata?.album)
        XCTAssertNotNil(kaczorck.thumbnail)
        
        XCTAssertEqual(bysiek.metadata?.title, "Life is a journey")
        XCTAssertEqual(bysiek.metadata?.artist, "Darqué")
        XCTAssertNil(bysiek.metadata?.album)
        XCTAssertNotNil(bysiek.thumbnail)
    }
    
    // MARK: - MockQueuedItem Tests
    
    func testMockQueuedItemInitialization() {
        let artwork = Artwork.url(URL(string: "https://example.com/artwork.jpg")!)
        let queuedItem = MockQueuedItem(
            id: NSNumber(value: 1),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        
        XCTAssertEqual(queuedItem.id, NSNumber(value: 1))
        XCTAssertEqual(queuedItem.title, "Test Track")
        XCTAssertEqual(queuedItem.artist, "Test Artist")
        XCTAssertEqual(queuedItem.album, "Test Album")
        XCTAssertEqual(queuedItem.artwork, artwork)
    }
    
    func testMockQueuedItemEquality() {
        let artwork = Artwork.url(URL(string: "https://example.com/artwork.jpg")!)
        
        let item1 = MockQueuedItem(
            id: NSNumber(value: 1),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        
        let item2 = MockQueuedItem(
            id: NSNumber(value: 1),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        
        let item3 = MockQueuedItem(
            id: NSNumber(value: 2),
            title: "Test Track",
            artist: "Test Artist",
            album: "Test Album",
            artwork: artwork
        )
        
        XCTAssertEqual(item1, item2)
        XCTAssertNotEqual(item1, item3)
    }
    
    // MARK: - MockGroup Tests
    
    func testMockGroupInitialization() {
        let member1 = MockGroupMember(role: .leader, id: "player1", name: "Player 1")
        let member2 = MockGroupMember(role: .member, id: "player2", name: "Player 2")
        
        let group = MockGroup(
            name: "Test Group",
            id: 1,
            members: [member1, member2]
        )
        
        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.id, 1)
        XCTAssertEqual(group.members.count, 2)
        XCTAssertEqual(group.leaderId, "player1")
        XCTAssertEqual(group.role(for: "player1"), .leader)
        XCTAssertEqual(group.role(for: "player2"), .member)
    }
    
    func testMockGroupMemberInitialization() {
        let member = MockGroupMember(
            role: .leader,
            id: "player1",
            name: "Test Player"
        )
        
        XCTAssertEqual(member.role, .leader)
        XCTAssertEqual(member.id, "player1")
        XCTAssertEqual(member.name, "Test Player")
    }
    
    func testMockGroupMemberEquality() {
        let member1 = MockGroupMember(role: .leader, id: "player1", name: "Player 1")
        let member2 = MockGroupMember(role: .leader, id: "player1", name: "Player 1")
        let member3 = MockGroupMember(role: .member, id: "player1", name: "Player 1")
        
        XCTAssertEqual(member1, member2)
        XCTAssertNotEqual(member1, member3) // Different role
    }
    
    // MARK: - MockManager Tests
    
    func testMockManagerInitialization() {
        let player1 = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let player2 = MockPlayer(id: "2", name: "Player 2", model: "Model 2")
        
        let group = MockGroup(
            name: "Test Group",
            id: 1,
            members: [
                MockGroupMember(role: .leader, id: "1", name: "Player 1"),
                MockGroupMember(role: .member, id: "2", name: "Player 2")
            ]
        )
        
        let manager = MockManager(
            renderers: [player1, player2],
            groups: [group]
        )
        
        XCTAssertEqual(manager.renderers.count, 2)
        XCTAssertEqual(manager.groups.count, 1)
        XCTAssertEqual(manager.renderer(withName: "Player 1"), player1)
        XCTAssertEqual(manager.renderer(withId: "1"), player1)
        XCTAssertNil(manager.renderer(withName: "Non-existent"))
        XCTAssertNil(manager.renderer(withId: "non-existent"))
    }
    
    func testMockManagerEquality() {
        let player = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let manager1 = MockManager(renderers: [player])
        let manager2 = MockManager(renderers: [player])
        
        // MockManager uses identity equality (===), so these should be different
        XCTAssertNotEqual(manager1, manager2)
        XCTAssertEqual(manager1, manager1) // Same instance
    }
    
    func testMockManagerPublishers() async {
        let player = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let manager = MockManager(renderers: [player])
        
        let renderersExpectation = XCTestExpectation(description: "Renderers published")
        let groupsExpectation = XCTestExpectation(description: "Groups published")
        
        manager.renderersPublisher
            .sink { renderers in
                XCTAssertEqual(renderers.count, 1)
                XCTAssertEqual(renderers.first?.name, "Player 1")
                renderersExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        manager.groupsPublisher
            .sink { groups in
                XCTAssertEqual(groups.count, 0)
                groupsExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [renderersExpectation, groupsExpectation], timeout: 1.0)
    }
    
    // MARK: - Integration Tests
    
    func testMockPlayerGroupIntegration() {
        let player1 = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let player2 = MockPlayer(id: "2", name: "Player 2", model: "Model 2")
        
        let group = MockGroup(
            name: "Living Room",
            id: 1,
            members: [
                MockGroupMember(role: .leader, id: "1", name: "Player 1"),
                MockGroupMember(role: .member, id: "2", name: "Player 2")
            ]
        )
        
        // Simulate group assignment
        player1.group = group
        player2.group = group
        
        XCTAssertEqual(player1.group?.name, "Living Room")
        XCTAssertEqual(player2.group?.name, "Living Room")
        XCTAssertEqual(player1.group?.leaderId, "1")
        XCTAssertEqual(player2.group?.leaderId, "1")
    }
    
    func testMockPlayerPlayQueueIntegration() {
        let player = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        
        let queuedItem1 = MockQueuedItem(
            id: NSNumber(value: 1),
            title: "Track 1",
            artist: "Artist 1",
            album: "Album 1",
            artwork: nil
        )
        
        let queuedItem2 = MockQueuedItem(
            id: NSNumber(value: 2),
            title: "Track 2",
            artist: "Artist 2",
            album: "Album 2",
            artwork: nil
        )
        
        player.playQueue = [queuedItem1, queuedItem2]
        
        XCTAssertEqual(player.playQueue.count, 2)
        XCTAssertEqual(player.playQueue[0].title, "Track 1")
        XCTAssertEqual(player.playQueue[1].title, "Track 2")
    }
    
    // MARK: - Async Method Tests
    
    func testMockPlayerAsyncMethods() async throws {
        let player = MockPlayer(id: "1", name: "Player 1", model: "Model 1")
        let mockItem = MockItemType(displayTitle: "Test Item")
        
        // These should not throw
        player.set(volume: 50)
        player.set(mute: true)
        player.set(zoneVolume: 30)
        player.set(zoneMute: false)
        try await player.addToQueue(item: mockItem, option: .playNow)
        try await player.removeFromQueue(items: [])
        try await player.clearQueue()
        try await player.moveQueue(items: [], insertAt: 0)
        
        // Test that these complete without errors
        XCTAssertTrue(true, "All async methods completed without throwing")
    }
} 
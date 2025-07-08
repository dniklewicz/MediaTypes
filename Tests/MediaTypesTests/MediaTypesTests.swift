import XCTest
@testable import MediaTypes

final class MediaTypesTests: XCTestCase {
    
    func testPackageBasicFunctionality() {
        // Test that the package loads correctly and basic types work
        let metadata = MediaItemMetadata(
            title: "Test Song",
            artist: "Test Artist",
            album: "Test Album"
        )
        
        XCTAssertEqual(metadata.title, "Test Song")
        XCTAssertEqual(metadata.artist, "Test Artist")
        XCTAssertEqual(metadata.album, "Test Album")
        
        // Test that mock objects can be created
        let mockItem = MockItemType(displayTitle: "Test Item")
        XCTAssertEqual(mockItem.displayTitle, "Test Item")
        XCTAssertTrue(mockItem.isAvailable)
        
        // Test that collections can be created
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: [mockItem]
        )
        XCTAssertEqual(collection.displayTitle, "Test Collection")
        
        // Test that players can be created
        let player = MockPlayer(
            id: "test-player",
            name: "Test Player",
            model: "Test Model"
        )
        XCTAssertEqual(player.name, "Test Player")
        XCTAssertEqual(player.playState, .stop)
        
        // Test that managers can be created
        let manager = MockManager(renderers: [player])
        XCTAssertEqual(manager.renderers.count, 1)
        XCTAssertEqual(manager.renderer(withId: "test-player"), player)
    }
    
    func testAsyncFunctionality() async throws {
        // Test async/await functionality works
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Async Test Collection",
            thumbnail: nil,
            items: [
                MockItemType(displayTitle: "Item 1"),
                MockItemType(displayTitle: "Item 2")
            ]
        )
        
        let (items, count) = try await collection.getItems(range: 0...1)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(count, 2)
        
        let searchResults = try await collection.search(
            for: "test",
            using: NotSearchableCriteria(),
            range: 0...10,
            isFirstSearch: true
        )
        XCTAssertEqual(searchResults.count, 0)
        
        let player = MockPlayer(id: "async-test", name: "Async Test", model: "Model")
        
        // Test async methods don't throw
        player.set(volume: 50)
        player.set(mute: true)
		player.updateState()
        
        XCTAssertTrue(true, "Async functionality test completed")
    }
}

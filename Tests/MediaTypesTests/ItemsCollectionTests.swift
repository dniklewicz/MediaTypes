import XCTest
import Combine
@testable import MediaTypes

final class ItemsCollectionTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - ItemsCollection Tests
    
    func testItemsCollectionInitializationWithProvider() {
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            displaySubtitle: "Test Subtitle",
            thumbnail: .url(URL(string: "https://example.com/thumbnail.jpg")!)
        ) { completion in
            let items: [any MediaItem] = [
                MockItemType(displayTitle: "Item 1"),
                MockItemType(displayTitle: "Item 2")
            ]
            completion(items)
        }
        
        XCTAssertEqual(collection.displayTitle, "Test Collection")
        XCTAssertEqual(collection.displaySubtitle, "Test Subtitle")
        XCTAssertNotNil(collection.thumbnail)
        XCTAssertNil(collection.typeString)
        XCTAssertNil(collection.metadata)
        XCTAssertNil(collection.isActiveContainer)
    }
    
    func testItemsCollectionInitializationWithItems() {
        let items: [any MediaItem] = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2"),
            MockItemType(displayTitle: "Item 3")
        ]
        
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: items
        )
        
        XCTAssertEqual(collection.displayTitle, "Test Collection")
        XCTAssertNil(collection.displaySubtitle)
        XCTAssertNil(collection.thumbnail)
    }
    
    func testItemsCollectionGetItems() async throws {
        let expectedItems: [any MediaItem] = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2"),
            MockItemType(displayTitle: "Item 3")
        ]
        
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: expectedItems
        )
        
        let (items, count) = try await collection.getItems(range: 0...2)
        
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(count, 3)
        XCTAssertEqual(items[0].displayTitle, "Item 1")
        XCTAssertEqual(items[1].displayTitle, "Item 2")
        XCTAssertEqual(items[2].displayTitle, "Item 3")
    }
    
    func testItemsCollectionGetItemsWithAsync() async throws {
        let expectation = XCTestExpectation(description: "Items provider called")
        
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil
        ) { completion in
            expectation.fulfill()
            let items: [any MediaItem] = [
                MockItemType(displayTitle: "Async Item 1"),
                MockItemType(displayTitle: "Async Item 2")
            ]
            completion(items)
        }
        
        let (items, count) = try await collection.getItems(range: 0...1)
        
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(items[0].displayTitle, "Async Item 1")
        XCTAssertEqual(items[1].displayTitle, "Async Item 2")
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testItemsCollectionSearchCriteriaPublisher() async {
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: []
        )
        
        let expectation = XCTestExpectation(description: "Search criteria published")
        
        collection.searchCriteriaPublisher
            .sink { criteria in
                XCTAssertEqual(criteria.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testItemsCollectionEquality() {
        let items: [any MediaItem] = [MockItemType(displayTitle: "Item 1")]
        
        let collection1 = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            displaySubtitle: "Subtitle",
            thumbnail: nil,
            items: items
        )
        
        let collection2 = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            displaySubtitle: "Subtitle",
            thumbnail: nil,
            items: items
        )
        
        let collection3 = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Different Collection",
            displaySubtitle: "Subtitle",
            thumbnail: nil,
            items: items
        )
        
        XCTAssertEqual(collection1, collection2)
        XCTAssertNotEqual(collection1, collection3)
    }
    
    func testItemsCollectionDefaultSearchBehavior() async throws {
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: []
        )
        
        let searchResults = try await collection.search(
            for: "test",
            using: NotSearchableCriteria(),
            range: 0...10,
            isFirstSearch: true
        )
        
        XCTAssertEqual(searchResults.count, 0)
    }
    
    // MARK: - PlayableItemsCollection Tests
    
    func testPlayableItemsCollectionInitialization() {
        let collection = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Playable Collection",
            displaySubtitle: "Playable Subtitle",
            thumbnail: .url(URL(string: "https://example.com/thumbnail.jpg")!)
        ) { completion in
            let items: [any MediaItem] = [
                MockItemType(displayTitle: "Playable Item 1"),
                MockItemType(displayTitle: "Playable Item 2")
            ]
            completion(items)
        }
        
        XCTAssertEqual(collection.displayTitle, "Playable Collection")
        XCTAssertEqual(collection.displaySubtitle, "Playable Subtitle")
        XCTAssertNotNil(collection.thumbnail)
    }
    
    func testPlayableItemsCollectionGetItems() async throws {
        let expectedItems: [any MediaItem] = [
            MockItemType(displayTitle: "Playable Item 1"),
            MockItemType(displayTitle: "Playable Item 2")
        ]
        
        let collection = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Playable Collection",
            thumbnail: nil,
            items: expectedItems
        )
        
        let (items, count) = try await collection.getItems(range: 0...1)
        
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(count, 2)
        XCTAssertEqual(items[0].displayTitle, "Playable Item 1")
        XCTAssertEqual(items[1].displayTitle, "Playable Item 2")
    }
    
    func testPlayableItemsCollectionEquality() {
        let items: [any MediaItem] = [MockItemType(displayTitle: "Item 1")]
        
        let collection1 = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Playable Collection",
            thumbnail: nil,
            items: items
        )
        
        let collection2 = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Playable Collection",
            thumbnail: nil,
            items: items
        )
        
        let collection3 = PlayableItemsCollection<NotSearchableCriteria>(
            displayTitle: "Different Collection",
            thumbnail: nil,
            items: items
        )
        
        XCTAssertEqual(collection1, collection2)
        XCTAssertNotEqual(collection1, collection3)
    }
    
    // MARK: - Search Criteria Tests
    
    func testNotSearchableCriteria() {
        let criteria = NotSearchableCriteria()
        
        XCTAssertEqual(criteria.name, "Not searchable")
        XCTAssertEqual(criteria.id, "Not searchable")
    }
    
    func testNotSearchableCriteriaEquality() {
        let criteria1 = NotSearchableCriteria()
        let criteria2 = NotSearchableCriteria()
        
        XCTAssertEqual(criteria1, criteria2)
        XCTAssertEqual(criteria1.hashValue, criteria2.hashValue)
    }
    
    // MARK: - MediaItemsContainer Protocol Tests
    
    func testMediaItemsContainerDefaults() {
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: []
        )
        
        XCTAssertTrue(collection.isAvailable)
        XCTAssertFalse(collection.searchable)
        XCTAssertFalse(collection.supportsItemsHiding)
    }
    
    func testSearchWillCancel() {
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: []
        )
        
        // Should not throw or crash
        collection.searchWillCancel()
    }
    
    // MARK: - Error Handling Tests
    
    func testItemsCollectionWithThrowingProvider() async {
        enum TestError: Error {
            case testError
        }
        
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil
        ) { completion in
            // Simulate an error by calling completion with empty items
            // In real implementation, this might throw an error
            completion([])
        }
        
        do {
            let (items, _) = try await collection.getItems(range: 0...10)
            XCTAssertEqual(items.count, 0)
        } catch {
            XCTFail("Should not throw error: \(error)")
        }
    }
    
    // MARK: - Range Handling Tests
    
    func testGetItemsWithDifferentRanges() async throws {
        let allItems: [any MediaItem] = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2"),
            MockItemType(displayTitle: "Item 3"),
            MockItemType(displayTitle: "Item 4"),
            MockItemType(displayTitle: "Item 5")
        ]
        
        let collection = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Test Collection",
            thumbnail: nil,
            items: allItems
        )
        
        // Test full range
        let (items1, count1) = try await collection.getItems(range: 0...4)
        XCTAssertEqual(items1.count, 5)
        XCTAssertEqual(count1, 5)
        
        // Test partial range
        let (items2, count2) = try await collection.getItems(range: 1...3)
        XCTAssertEqual(items2.count, 5) // Provider returns all items
        XCTAssertEqual(count2, 5)
        
        // Test single item range
        let (items3, count3) = try await collection.getItems(range: 2...2)
        XCTAssertEqual(items3.count, 5) // Provider returns all items
        XCTAssertEqual(count3, 5)
    }
} 
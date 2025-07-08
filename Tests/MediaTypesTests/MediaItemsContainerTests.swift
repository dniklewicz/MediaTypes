import XCTest
import Combine
@testable import MediaTypes

// MARK: - Custom Test SearchCriteria

struct TestSearchCriteria: MediaSearchCriteria {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init() {
        self.name = "Default"
    }
}

struct AnotherSearchCriteria: MediaSearchCriteria {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init() {
        self.name = "Another"
    }
}

// MARK: - Test MediaItemsContainer Implementation

class TestMediaItemsContainer: MediaItemsContainer, @unchecked Sendable {
    public typealias SearchCriteria = TestSearchCriteria
    
    public var thumbnail: Artwork?
    public var displayTitle: String
    public var displaySubtitle: String?
    public var isAvailable: Bool
    public var searchCriteria: [TestSearchCriteria]
    public var isActiveContainer: Bool?
    public var supportsItemsHiding: Bool
    
    public var typeString: String? { "TestContainer" }
    public var metadata: MediaItemMetadata? { nil }
    
    public static func == (lhs: TestMediaItemsContainer, rhs: TestMediaItemsContainer) -> Bool {
        return lhs.displayTitle == rhs.displayTitle &&
               lhs.displaySubtitle == rhs.displaySubtitle &&
               lhs.thumbnail == rhs.thumbnail &&
               lhs.isAvailable == rhs.isAvailable &&
               lhs.searchCriteria == rhs.searchCriteria &&
               lhs.isActiveContainer == rhs.isActiveContainer &&
               lhs.supportsItemsHiding == rhs.supportsItemsHiding
    }
    
    private var items: [any MediaItem] = []
    private var searchResults: [String: [any MediaItem]] = [:]
    private var shouldThrowError = false
    private var searchDelay: TimeInterval = 0
    private var getItemsDelay: TimeInterval = 0
    private var searchWillCancelCalled = false
    private var _searchCallCount = 0
    private var _getItemsCallCount = 0
    private let counterLock = NSLock()
    
    public init(
        displayTitle: String,
        displaySubtitle: String? = nil,
        thumbnail: Artwork? = nil,
        isAvailable: Bool = true,
        searchCriteria: [TestSearchCriteria] = [],
        isActiveContainer: Bool? = nil,
        supportsItemsHiding: Bool = false,
        items: [any MediaItem] = []
    ) {
        self.displayTitle = displayTitle
        self.displaySubtitle = displaySubtitle
        self.thumbnail = thumbnail
        self.isAvailable = isAvailable
        self.searchCriteria = searchCriteria
        self.isActiveContainer = isActiveContainer
        self.supportsItemsHiding = supportsItemsHiding
        self.items = items
    }
    
    public func search(
        for keyword: String,
        using criteria: TestSearchCriteria,
        range: ClosedRange<Int>,
        isFirstSearch: Bool
    ) async throws -> [any MediaItem] {
        counterLock.withLock {
            _searchCallCount += 1
        }
        
        if shouldThrowError {
            throw TestError.searchFailed
        }
        
        if searchDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(searchDelay * 1_000_000_000))
        }
        
        let key = "\(keyword)_\(criteria.name)"
        let results = searchResults[key] ?? []
        
        // Simulate range filtering
        let startIndex = max(0, range.lowerBound)
        let endIndex = min(results.count - 1, range.upperBound)
        
        if startIndex <= endIndex && startIndex < results.count {
            return Array(results[startIndex...endIndex])
        }
        
        return []
    }
    
    public func searchWillCancel() {
        counterLock.withLock {
            searchWillCancelCalled = true
        }
    }
    
    public func getItems(range: ClosedRange<Int>) async throws -> ([any MediaItem], Int?) {
        counterLock.withLock {
            _getItemsCallCount += 1
        }
        
        if shouldThrowError {
            throw TestError.getItemsFailed
        }
        
        if getItemsDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(getItemsDelay * 1_000_000_000))
        }
        
        let startIndex = max(0, range.lowerBound)
        let endIndex = min(items.count - 1, range.upperBound)
        
        if startIndex <= endIndex && startIndex < items.count {
            return (Array(items[startIndex...endIndex]), items.count)
        }
        
        return ([], items.count)
    }
    
    // MARK: - Test Helper Methods
    
    func setSearchResults(_ results: [String: [any MediaItem]]) {
        self.searchResults = results
    }
    
    func setShouldThrowError(_ shouldThrow: Bool) {
        self.shouldThrowError = shouldThrow
    }
    
    func setSearchDelay(_ delay: TimeInterval) {
        self.searchDelay = delay
    }
    
    func setGetItemsDelay(_ delay: TimeInterval) {
        self.getItemsDelay = delay
    }
    
    func getSearchWillCancelCalled() -> Bool {
        counterLock.withLock {
            searchWillCancelCalled
        }
    }
    
    func getSearchCallCount() -> Int {
        counterLock.withLock {
            _searchCallCount
        }
    }
    
    func getGetItemsCallCount() -> Int {
        counterLock.withLock {
            _getItemsCallCount
        }
    }
    
    func resetCounters() {
        counterLock.withLock {
            _searchCallCount = 0
            _getItemsCallCount = 0
            searchWillCancelCalled = false
        }
    }
}

// MARK: - Test Error Types

enum TestError: Error {
    case searchFailed
    case getItemsFailed
    case networkError
    case timeout
}

// MARK: - MediaItemsContainer Tests

final class MediaItemsContainerTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Protocol Property Tests
    
    func testMediaItemsContainerProperties() {
        let container = TestMediaItemsContainer(
            displayTitle: "Test Container",
            displaySubtitle: "Test Subtitle",
            thumbnail: .url(URL(string: "https://example.com/image.jpg")!),
            isAvailable: true,
            searchCriteria: [TestSearchCriteria(name: "Title"), TestSearchCriteria(name: "Artist")],
            isActiveContainer: true,
            supportsItemsHiding: true
        )
        
        XCTAssertEqual(container.displayTitle, "Test Container")
        XCTAssertEqual(container.displaySubtitle, "Test Subtitle")
        XCTAssertNotNil(container.thumbnail)
        XCTAssertTrue(container.isAvailable)
        XCTAssertEqual(container.searchCriteria.count, 2)
        XCTAssertEqual(container.isActiveContainer, true)
        XCTAssertTrue(container.supportsItemsHiding)
        XCTAssertEqual(container.typeString, "TestContainer")
    }
    
    func testMediaItemsContainerDefaultValues() {
        let container = TestMediaItemsContainer(displayTitle: "Default Container")
        
        XCTAssertNil(container.displaySubtitle)
        XCTAssertNil(container.thumbnail)
        XCTAssertTrue(container.isAvailable) // Default from protocol extension
        XCTAssertEqual(container.searchCriteria.count, 0)
        XCTAssertNil(container.isActiveContainer)
        XCTAssertFalse(container.supportsItemsHiding) // Default from protocol extension
    }
    
    func testSearchableProperty() {
        let nonSearchableContainer = TestMediaItemsContainer(
            displayTitle: "Non-searchable",
            searchCriteria: []
        )
        XCTAssertFalse(nonSearchableContainer.searchable)
        
        let searchableContainer = TestMediaItemsContainer(
            displayTitle: "Searchable",
            searchCriteria: [TestSearchCriteria(name: "Title")]
        )
        XCTAssertTrue(searchableContainer.searchable)
    }
    
    // MARK: - Search Functionality Tests
    
    func testSearchWithResults() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Search Container",
            searchCriteria: [TestSearchCriteria(name: "Title")]
        )
        
        let expectedItems = [
            MockItemType(displayTitle: "Search Result 1"),
            MockItemType(displayTitle: "Search Result 2")
        ]
        
        container.setSearchResults(["test_Title": expectedItems])
        
        let results = try await container.search(
            for: "test",
            using: TestSearchCriteria(name: "Title"),
            range: 0...10,
            isFirstSearch: true
        )
        
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].displayTitle, "Search Result 1")
        XCTAssertEqual(results[1].displayTitle, "Search Result 2")
        XCTAssertEqual(container.getSearchCallCount(), 1)
    }
    
    func testSearchWithEmptyResults() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Search Container",
            searchCriteria: [TestSearchCriteria(name: "Title")]
        )
        
        let results = try await container.search(
            for: "nonexistent",
            using: TestSearchCriteria(name: "Title"),
            range: 0...10,
            isFirstSearch: true
        )
        
        XCTAssertEqual(results.count, 0)
    }
    
    func testSearchWithRange() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Search Container"
        )
        
        let allResults = [
            MockItemType(displayTitle: "Result 1"),
            MockItemType(displayTitle: "Result 2"),
            MockItemType(displayTitle: "Result 3"),
            MockItemType(displayTitle: "Result 4"),
            MockItemType(displayTitle: "Result 5")
        ]
        
        container.setSearchResults(["test_Title": allResults])
        
        let results = try await container.search(
            for: "test",
            using: TestSearchCriteria(name: "Title"),
            range: 1...3,
            isFirstSearch: false
        )
        
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0].displayTitle, "Result 2")
        XCTAssertEqual(results[1].displayTitle, "Result 3")
        XCTAssertEqual(results[2].displayTitle, "Result 4")
    }
    
    func testSearchDefaultOverload() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Search Container"
        )
        
        let expectedItems = [MockItemType(displayTitle: "Default Search Result")]
        container.setSearchResults(["test_Title": expectedItems])
        
        // Test the default overload that doesn't take isFirstSearch parameter
        let results = try await container.search(
            for: "test",
            using: TestSearchCriteria(name: "Title"),
            range: 0...10
        )
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(container.getSearchCallCount(), 1)
    }
    
    func testSearchWillCancel() {
        let container = TestMediaItemsContainer(displayTitle: "Cancel Container")
        
        XCTAssertFalse(container.getSearchWillCancelCalled())
        
        container.searchWillCancel()
        
        XCTAssertTrue(container.getSearchWillCancelCalled())
    }
    
    // MARK: - GetItems Functionality Tests
    
    func testGetItemsWithResults() async throws {
        let items = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2"),
            MockItemType(displayTitle: "Item 3")
        ]
        
        let container = TestMediaItemsContainer(
            displayTitle: "Items Container",
            items: items
        )
        
        let (resultItems, count) = try await container.getItems(range: 0...2)
        
        XCTAssertEqual(resultItems.count, 3)
        XCTAssertEqual(count, 3)
        XCTAssertEqual(resultItems[0].displayTitle, "Item 1")
        XCTAssertEqual(resultItems[1].displayTitle, "Item 2")
        XCTAssertEqual(resultItems[2].displayTitle, "Item 3")
    }
    
    func testGetItemsWithPartialRange() async throws {
        let items = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2"),
            MockItemType(displayTitle: "Item 3"),
            MockItemType(displayTitle: "Item 4"),
            MockItemType(displayTitle: "Item 5")
        ]
        
        let container = TestMediaItemsContainer(
            displayTitle: "Items Container",
            items: items
        )
        
        let (resultItems, count) = try await container.getItems(range: 1...3)
        
        XCTAssertEqual(resultItems.count, 3)
        XCTAssertEqual(count, 5)
        XCTAssertEqual(resultItems[0].displayTitle, "Item 2")
        XCTAssertEqual(resultItems[1].displayTitle, "Item 3")
        XCTAssertEqual(resultItems[2].displayTitle, "Item 4")
    }
    
    func testGetItemsWithEmptyCollection() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Empty Container",
            items: []
        )
        
        let (resultItems, count) = try await container.getItems(range: 0...10)
        
        XCTAssertEqual(resultItems.count, 0)
        XCTAssertEqual(count, 0)
    }
    
    func testGetItemsWithOutOfBoundsRange() async throws {
        let items = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2")
        ]
        
        let container = TestMediaItemsContainer(
            displayTitle: "Items Container",
            items: items
        )
        
        let (resultItems, count) = try await container.getItems(range: 5...10)
        
        XCTAssertEqual(resultItems.count, 0)
        XCTAssertEqual(count, 2)
    }
    
    // MARK: - Error Handling Tests
    
    func testSearchErrorHandling() async {
        let container = TestMediaItemsContainer(displayTitle: "Error Container")
        container.setShouldThrowError(true)
        
        do {
            _ = try await container.search(
                for: "test",
                using: TestSearchCriteria(name: "Title"),
                range: 0...10,
                isFirstSearch: true
            )
            XCTFail("Expected error to be thrown")
        } catch TestError.searchFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testGetItemsErrorHandling() async {
        let container = TestMediaItemsContainer(displayTitle: "Error Container")
        container.setShouldThrowError(true)
        
        do {
            _ = try await container.getItems(range: 0...10)
            XCTFail("Expected error to be thrown")
        } catch TestError.getItemsFailed {
            // Expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentGetItemsCalls() async throws {
        let items = Array(1...100).map { MockItemType(displayTitle: "Item \($0)") }
        let container = TestMediaItemsContainer(
            displayTitle: "Concurrent Container",
            items: items
        )
        
        // Make multiple concurrent calls
        async let result1 = container.getItems(range: 0...10)
        async let result2 = container.getItems(range: 20...30)
        async let result3 = container.getItems(range: 50...60)
        
        let (items1, count1) = try await result1
        let (items2, count2) = try await result2
        let (items3, count3) = try await result3
        
        XCTAssertEqual(items1.count, 11)
        XCTAssertEqual(items2.count, 11)
        XCTAssertEqual(items3.count, 11)
        XCTAssertEqual(count1, 100)
        XCTAssertEqual(count2, 100)
        XCTAssertEqual(count3, 100)
        XCTAssertEqual(container.getGetItemsCallCount(), 3)
    }
    
    func testConcurrentSearchCalls() async throws {
        let container = TestMediaItemsContainer(displayTitle: "Concurrent Container")
        
        let results1 = Array(1...5).map { MockItemType(displayTitle: "Result 1-\($0)") }
        let results2 = Array(1...3).map { MockItemType(displayTitle: "Result 2-\($0)") }
        let results3 = Array(1...7).map { MockItemType(displayTitle: "Result 3-\($0)") }
        
        container.setSearchResults([
            "query1_Title": results1,
            "query2_Artist": results2,
            "query3_Album": results3
        ])
        
        // Make multiple concurrent search calls
        async let search1 = container.search(for: "query1", using: TestSearchCriteria(name: "Title"), range: 0...10, isFirstSearch: true)
        async let search2 = container.search(for: "query2", using: TestSearchCriteria(name: "Artist"), range: 0...10, isFirstSearch: true)
        async let search3 = container.search(for: "query3", using: TestSearchCriteria(name: "Album"), range: 0...10, isFirstSearch: true)
        
        let searchResults1 = try await search1
        let searchResults2 = try await search2
        let searchResults3 = try await search3
        
        XCTAssertEqual(searchResults1.count, 5)
        XCTAssertEqual(searchResults2.count, 3)
        XCTAssertEqual(searchResults3.count, 7)
        XCTAssertEqual(container.getSearchCallCount(), 3)
    }
    
    // MARK: - Performance Tests
    
    func testLargeDatasetPerformance() async throws {
        let largeDataset = Array(1...10000).map { MockItemType(displayTitle: "Item \($0)") }
        let container = TestMediaItemsContainer(
            displayTitle: "Large Dataset Container",
            items: largeDataset
        )
        
        let startTime = CFAbsoluteTimeGetCurrent()
        let (items, count) = try await container.getItems(range: 0...999)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        XCTAssertEqual(items.count, 1000)
        XCTAssertEqual(count, 10000)
        
        // Performance should be reasonable (less than 1 second)
        let executionTime = endTime - startTime
        XCTAssertLessThan(executionTime, 1.0, "GetItems should complete in less than 1 second")
    }
    
    // MARK: - Search Criteria Tests
    
    func testCustomSearchCriteria() {
        let criteria1 = TestSearchCriteria(name: "Title")
        let criteria2 = TestSearchCriteria(name: "Artist")
        let criteria3 = TestSearchCriteria(name: "Title")
        
        XCTAssertEqual(criteria1.name, "Title")
        XCTAssertEqual(criteria1.id, "Title")
        XCTAssertEqual(criteria2.name, "Artist")
        XCTAssertEqual(criteria2.id, "Artist")
        
        XCTAssertEqual(criteria1, criteria3)
        XCTAssertNotEqual(criteria1, criteria2)
        XCTAssertEqual(criteria1.hashValue, criteria3.hashValue)
    }
    
    func testMultipleSearchCriteriaTypes() {
        let container = TestMediaItemsContainer(
            displayTitle: "Multi-Criteria Container",
            searchCriteria: [
                TestSearchCriteria(name: "Title"),
                TestSearchCriteria(name: "Artist"),
                TestSearchCriteria(name: "Album")
            ]
        )
        
        XCTAssertEqual(container.searchCriteria.count, 3)
        XCTAssertTrue(container.searchable)
        
        let criteriaNames = container.searchCriteria.map { $0.name }
        XCTAssertTrue(criteriaNames.contains("Title"))
        XCTAssertTrue(criteriaNames.contains("Artist"))
        XCTAssertTrue(criteriaNames.contains("Album"))
    }
    
    // MARK: - Protocol Extension Tests
    
    func testNotSearchableCriteriaExtension() {
        let container = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Non-searchable Collection",
            thumbnail: nil,
            items: []
        )
        
        XCTAssertEqual(container.searchCriteria.count, 0)
        XCTAssertFalse(container.searchable)
    }
    
    func testNotSearchableCriteriaSearchBehavior() async throws {
        let container = ItemsCollection<NotSearchableCriteria>(
            displayTitle: "Non-searchable Collection",
            thumbnail: nil,
            items: [MockItemType(displayTitle: "Test Item")]
        )
        
        // Search should return empty results for non-searchable containers
        let results = try await container.search(
            for: "test",
            using: NotSearchableCriteria(),
            range: 0...10,
            isFirstSearch: true
        )
        
        XCTAssertEqual(results.count, 0)
        
        // searchWillCancel should be a no-op
        container.searchWillCancel() // Should not crash
    }
    
    // MARK: - Edge Cases
    
    func testEmptyRangeHandling() async throws {
        let container = TestMediaItemsContainer(
            displayTitle: "Empty Range Container",
            items: [MockItemType(displayTitle: "Test Item")]
        )
        
        // Test with range where lowerBound > upperBound (invalid range)
        // This should be caught at compile time, but we can test boundary conditions
        
        let (items, count) = try await container.getItems(range: 0...0)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(count, 1)
    }
    
    func testNegativeRangeHandling() async throws {
        let items = [
            MockItemType(displayTitle: "Item 1"),
            MockItemType(displayTitle: "Item 2")
        ]
        
        let container = TestMediaItemsContainer(
            displayTitle: "Negative Range Container",
            items: items
        )
        
        // Test with negative range values - should be handled gracefully
        let (resultItems, count) = try await container.getItems(range: -1...1)
        
        // Implementation should handle negative indices gracefully
        XCTAssertEqual(resultItems.count, 2)
        XCTAssertEqual(count, 2)
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryManagement() async throws {
        var container: TestMediaItemsContainer? = TestMediaItemsContainer(
            displayTitle: "Memory Test Container",
            items: Array(1...1000).map { MockItemType(displayTitle: "Item \($0)") }
        )
        
        weak var weakContainer = container
        
        // Perform some operations
        let (_, _) = try await container!.getItems(range: 0...100)
        
        // Release the strong reference
        container = nil
        
        // The container should be deallocated
        XCTAssertNil(weakContainer)
    }
} 
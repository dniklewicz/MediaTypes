import XCTest
import SwiftUI
@testable import MediaTypes

final class MediaItemTests: XCTestCase {
    
    // MARK: - MediaItemMetadata Tests
    
    func testMediaItemMetadataInitialization() {
        // Test basic initialization
        let metadata = MediaItemMetadata(
            title: "Test Song",
            artist: "Test Artist",
            album: "Test Album"
        )
        
        XCTAssertEqual(metadata.title, "Test Song")
        XCTAssertEqual(metadata.artist, "Test Artist")
        XCTAssertEqual(metadata.album, "Test Album")
    }
    
    func testMediaItemMetadataWithNilValues() {
        // Test initialization with nil values
        let metadata = MediaItemMetadata(
            title: "Test Song",
            artist: nil,
            album: nil
        )
        
        XCTAssertEqual(metadata.title, "Test Song")
        XCTAssertNil(metadata.artist)
        XCTAssertNil(metadata.album)
    }
    
    func testMediaItemMetadataEquality() {
        // Test equality comparison
        let metadata1 = MediaItemMetadata(
            title: "Test Song",
            artist: "Test Artist",
            album: "Test Album"
        )
        
        let metadata2 = MediaItemMetadata(
            title: "Test Song",
            artist: "Test Artist",
            album: "Test Album"
        )
        
        let metadata3 = MediaItemMetadata(
            title: "Different Song",
            artist: "Test Artist",
            album: "Test Album"
        )
        
        XCTAssertEqual(metadata1, metadata2)
        XCTAssertNotEqual(metadata1, metadata3)
    }
    
    // MARK: - MediaItem Protocol Tests
    
    func testMockItemTypeBasicProperties() {
        let mockItem = MockItemType(
            thumbnail: .url(URL(string: "https://example.com/image.jpg")!),
            displayTitle: "Test Title",
            displaySubtitle: "Test Subtitle",
            metadata: MediaItemMetadata(title: "Test", artist: "Artist", album: "Album"),
            typeString: "song"
        )
        
        XCTAssertEqual(mockItem.displayTitle, "Test Title")
        XCTAssertEqual(mockItem.displaySubtitle, "Test Subtitle")
        XCTAssertEqual(mockItem.typeString, "song")
        XCTAssertEqual(mockItem.metadata?.title, "Test")
        XCTAssertEqual(mockItem.metadata?.artist, "Artist")
        XCTAssertEqual(mockItem.metadata?.album, "Album")
    }
    
    func testMockItemTypeDefaults() {
        let mockItem = MockItemType(displayTitle: "Test Title")
        
        XCTAssertEqual(mockItem.displayTitle, "Test Title")
        XCTAssertNil(mockItem.displaySubtitle)
        XCTAssertNil(mockItem.thumbnail)
        XCTAssertNil(mockItem.metadata)
        XCTAssertNil(mockItem.typeString)
        
        // Test default protocol implementations
        XCTAssertTrue(mockItem.isAvailable)
        XCTAssertFalse(mockItem.isQueueable)
        XCTAssertEqual(mockItem.id, "Test Title")
    }
    
    func testMockItemTypeEquality() {
        let mockItem1 = MockItemType(displayTitle: "Test Title")
        let mockItem2 = MockItemType(displayTitle: "Test Title")
        let mockItem3 = MockItemType(displayTitle: "Different Title")
        
        XCTAssertEqual(mockItem1, mockItem2)
        XCTAssertNotEqual(mockItem1, mockItem3)
    }
    
    // MARK: - Artwork Tests
    
    func testArtworkURL() {
        let testURL = URL(string: "https://example.com/image.jpg")!
        let urlArtwork = Artwork.url(testURL)
        
        XCTAssertEqual(urlArtwork.url, testURL)
        
        let imageArtwork = Artwork.image(Image(systemName: "music.note"))
        XCTAssertNil(imageArtwork.url)
    }
    
    func testArtworkEquality() {
        let url1 = URL(string: "https://example.com/image.jpg")!
        let url2 = URL(string: "https://example.com/image.jpg")!
        let url3 = URL(string: "https://example.com/different.jpg")!
        
        let artwork1 = Artwork.url(url1)
        let artwork2 = Artwork.url(url2)
        let artwork3 = Artwork.url(url3)
        
        XCTAssertEqual(artwork1, artwork2)
        XCTAssertNotEqual(artwork1, artwork3)
    }
    
    // MARK: - PlaybackProgress Tests
    
    func testPlaybackProgressCalculations() {
        let progress = PlaybackProgress(currentTime: 30, totalTime: 120)
        
        XCTAssertEqual(progress.currentTime, 30)
        XCTAssertEqual(progress.totalTime, 120)
        XCTAssertEqual(progress.progress, 0.25, accuracy: 0.001)
        XCTAssertEqual(progress.remainingTime, 90)
    }
    
    func testPlaybackProgressEquality() {
        let progress1 = PlaybackProgress(currentTime: 30, totalTime: 120)
        let progress2 = PlaybackProgress(currentTime: 30, totalTime: 120)
        let progress3 = PlaybackProgress(currentTime: 45, totalTime: 120)
        
        XCTAssertEqual(progress1, progress2)
        XCTAssertNotEqual(progress1, progress3)
    }
    
    // MARK: - RepeatMode Tests
    
    func testRepeatModeDisplayStrings() {
        XCTAssertEqual(RepeatMode.all.displayString, "ALL")
        XCTAssertEqual(RepeatMode.one.displayString, "ONE")
        XCTAssertEqual(RepeatMode.off.displayString, "OFF")
    }
    
    func testRepeatModeNext() {
        XCTAssertEqual(RepeatMode.all.next(), .one)
        XCTAssertEqual(RepeatMode.one.next(), .off)
        XCTAssertEqual(RepeatMode.off.next(), .all)
    }
    
    // MARK: - ShuffleMode Tests
    
    func testShuffleModeDisplayStrings() {
        XCTAssertEqual(ShuffleMode.on.displayString, "ON")
        XCTAssertEqual(ShuffleMode.off.displayString, "OFF")
    }
    
    func testShuffleModeNext() {
        XCTAssertEqual(ShuffleMode.on.next(), .off)
        XCTAssertEqual(ShuffleMode.off.next(), .on)
    }
    
    // MARK: - PlayState Tests
    
    func testPlayStateValues() {
        XCTAssertEqual(PlayState.play.rawValue, "play")
        XCTAssertEqual(PlayState.pause.rawValue, "pause")
        XCTAssertEqual(PlayState.stop.rawValue, "stop")
        XCTAssertEqual(PlayState.transitioning.rawValue, "transitioning")
    }
    
    // MARK: - PlaybackAction Tests
    
    func testPlaybackActionAllCases() {
        let expectedCases: [PlaybackAction] = [.play, .stop, .pause, .next, .previous, .restart]
        XCTAssertEqual(Set(PlaybackAction.allCases), Set(expectedCases))
    }
} 
import XCTest
@testable import MicropubAPI

final class MediaTests: XCTestCase {

    func testJPEG() throws {
        // Given
        let mediaData = "mock_data".data(using: .utf8)

        // When
        let media = Media.jpeg(mediaData)

        // Then
        XCTAssertEqual(media.data, mediaData)
        XCTAssertEqual(media.fileName, "file.jpg")
        XCTAssertEqual(media.mimeType, "image/jpg")
    }

    func testGIF() throws {
        // Given
        let mediaData = "mock_data".data(using: .utf8)

        // When
        let media = Media.gif(mediaData)

        // Then
        XCTAssertEqual(media.data, mediaData)
        XCTAssertEqual(media.fileName, "file.gif")
        XCTAssertEqual(media.mimeType, "image/gif")
    }

    func testPNG() throws {
        // Given
        let mediaData = "mock_data".data(using: .utf8)

        // When
        let media = Media.png(mediaData)

        // Then
        XCTAssertEqual(media.data, mediaData)
        XCTAssertEqual(media.fileName, "file.png")
        XCTAssertEqual(media.mimeType, "image/png")
    }

    func testOther() throws {
        // Given
        let mediaData = "mock_data".data(using: .utf8)

        // When
        let media = Media.other(
            mediaData,
            fileExtension: "toto",
            mimeType: "foo/bar"
        )

        // Then
        XCTAssertEqual(media.data, mediaData)
        XCTAssertEqual(media.fileName, "file.toto")
        XCTAssertEqual(media.mimeType, "foo/bar")
    }
}

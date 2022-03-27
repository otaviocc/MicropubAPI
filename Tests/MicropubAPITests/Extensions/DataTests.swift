import XCTest
@testable import MicropubAPI

final class DataTests: XCTestCase {

    func testDataMedia() throws {
        // Given
        let mediaData = "mock_data".data(using: .utf8)

        let media = Media.other(
            mediaData,
            fileExtension: "toto",
            mimeType: "foo/bar"
        )

        // When
        let data = Data(
            media: media,
            boundary: "mock_boundary"
        )

        // Then
        let formDataContent = String(
            data: try XCTUnwrap(data),
            encoding: .utf8
        )

        XCTAssertEqual(
            formDataContent,
            "--mock_boundary\r\nContent-Disposition: form-data; name=\"file\"; filename=\"file.toto\"\r\nContent-Type: foo/bar\r\n\r\nmock_data\r\n--mock_boundary--\r\n"
        )
    }
}

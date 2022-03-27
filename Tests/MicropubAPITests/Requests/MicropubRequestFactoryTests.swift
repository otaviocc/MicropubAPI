import XCTest
import MicroClient
@testable import MicropubAPI

final class MicropubRequestFactoryTests: XCTestCase {

    // MARK: - Tests

    func testMakeNewPostRequestRequired() {
        let request = MicropubRequestFactory.makeNewPostRequest(
            content: "This is the post content"
        )

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 2)
        XCTAssertEqual(request.formItems?.first { $0.name == "h" }?.value, "entry")
        XCTAssertEqual(request.formItems?.first { $0.name == "content" }?.value, "This is the post content")
    }

    func testMakeNewPostRequestOptionals() {
        let publishedDate = Date.distantPast
        let updatedDate = Date.distantFuture
        let photoURL = URL(string: "http://localhost/fake/image.jpg")
        let syndicateURL = URL(string: "http://localhost/fake/syndicate")

        // Given

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current

        // When

        let request = MicropubRequestFactory.makeNewPostRequest(
            name: "This is the post title",
            summary: "This is the post summary",
            content: "This is the post content",
            published: publishedDate,
            updated: updatedDate,
            categories: ["category1", "category2"],
            photoURL: photoURL,
            photoDescription: "This is the photo description",
            syndicateURL: syndicateURL
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 11)
        XCTAssertEqual(request.formItems?.first { $0.name == "h" }?.value, "entry")
        XCTAssertEqual(request.formItems?.first { $0.name == "name" }?.value, "This is the post title")
        XCTAssertEqual(request.formItems?.first { $0.name == "summary" }?.value, "This is the post summary")
        XCTAssertEqual(request.formItems?.first { $0.name == "content" }?.value, "This is the post content")
        XCTAssertEqual(request.formItems?.first { $0.name == "published" }?.value, dateFormatter.string(from: publishedDate))
        XCTAssertEqual(request.formItems?.first { $0.name == "updated" }?.value, dateFormatter.string(from: updatedDate))
        XCTAssertEqual(request.formItems?.first { $0.name == "photo" }?.value, "http://localhost/fake/image.jpg")
        XCTAssertEqual(request.formItems?.first { $0.name == "mp-photo-alt" }?.value, "This is the photo description")
        XCTAssertEqual(request.formItems?.first { $0.name == "mp-syndicate-to" }?.value, "http://localhost/fake/syndicate")
        XCTAssertEqual(request.formItems?.first { $0.name == "category[]" }?.value, "category1")
        XCTAssertEqual(request.formItems?.last { $0.name == "category[]" }?.value, "category2")
    }

    func testMakeReplyRequest() {
        let publishedDate = Date.distantPast
        let replyToURL = URL(string: "http://localhost/fake/reply")!
        let syndicateURL = URL(string: "http://localhost/fake/syndicate")

        // Given

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current

        // When

        let request = MicropubRequestFactory.makeReplyRequest(
            content: "This is the post content",
            replyToURL: replyToURL,
            syndicateURL: syndicateURL,
            published: publishedDate
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 5)
        XCTAssertEqual(request.formItems?.first { $0.name == "h" }?.value, "entry")
        XCTAssertEqual(request.formItems?.first { $0.name == "content" }?.value, "This is the post content")
        XCTAssertEqual(request.formItems?.first { $0.name == "published" }?.value, dateFormatter.string(from: publishedDate))
        XCTAssertEqual(request.formItems?.first { $0.name == "in-reply-to" }?.value, "http://localhost/fake/reply")
        XCTAssertEqual(request.formItems?.first { $0.name == "mp-syndicate-to" }?.value, "http://localhost/fake/syndicate")
    }

    func testMakeRepostRequest() {
        let repostURL = URL(string: "http://localhost/fake/repost")!

        // When

        let request = MicropubRequestFactory.makeRepostRequest(
            repostURL: repostURL,
            categories: ["category1", "category2"]
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 4)
        XCTAssertEqual(request.formItems?.first { $0.name == "h" }?.value, "entry")
        XCTAssertEqual(request.formItems?.first { $0.name == "repost-of" }?.value, "http://localhost/fake/repost")
        XCTAssertEqual(request.formItems?.first { $0.name == "category[]" }?.value, "category1")
        XCTAssertEqual(request.formItems?.last { $0.name == "category[]" }?.value, "category2")
    }

    func testMakeBookmarkRequest() {
        let bookmarkURL = URL(string: "http://localhost/fake/bookmark")!

        // When

        let request = MicropubRequestFactory.makeBookmarkRequest(
            name: "This is the bookmark title",
            content: "This is the bookmark description",
            bookmarkURL: bookmarkURL,
            categories: ["category1", "category2"]
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 6)
        XCTAssertEqual(request.formItems?.first { $0.name == "h" }?.value, "entry")
        XCTAssertEqual(request.formItems?.first { $0.name == "name" }?.value, "This is the bookmark title")
        XCTAssertEqual(request.formItems?.first { $0.name == "content" }?.value, "This is the bookmark description")
        XCTAssertEqual(request.formItems?.first { $0.name == "bookmark-of" }?.value, "http://localhost/fake/bookmark")
        XCTAssertEqual(request.formItems?.first { $0.name == "category[]" }?.value, "category1")
        XCTAssertEqual(request.formItems?.last { $0.name == "category[]" }?.value, "category2")
    }

    func testMakeConfigurationRequest() {
        // When

        let request = MicropubRequestFactory.makeConfigurationRequest()

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .get)
        XCTAssertEqual(request.queryItems?.filter { $0.value != nil }.count, 1)
        XCTAssertEqual(request.queryItems?.first { $0.name == "q" }?.value, "config")
    }

    func testMakeActionRequestDelete() {
        let someURL = URL(string: "http://localhost/fake/some")!

        // When

        let request = MicropubRequestFactory.makeActionRequest(
            action: .delete,
            url: someURL
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 2)
        XCTAssertEqual(request.formItems?.first { $0.name == "action" }?.value, "delete")
        XCTAssertEqual(request.formItems?.first { $0.name == "url" }?.value, "http://localhost/fake/some")
    }

    func testMakeActionRequestUndelete() {
        let someURL = URL(string: "http://localhost/fake/some")!

        // When

        let request = MicropubRequestFactory.makeActionRequest(
            action: .undelete,
            url: someURL
        )

        // Then

        XCTAssertEqual(request.path, "/micropub")
        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.formItems?.filter { $0.value != nil }.count, 2)
        XCTAssertEqual(request.formItems?.first { $0.name == "action" }?.value, "undelete")
        XCTAssertEqual(request.formItems?.first { $0.name == "url" }?.value, "http://localhost/fake/some")
    }

    func testMakeUploadRequest() throws {
        let mediaURL = URL(string: "http://localhost/mediaUpload")!
        let mediaData = "mock_data".data(using: .utf8)

        // Given

        let media = Media.other(
            mediaData,
            fileExtension: "toto",
            mimeType: "foo/bar"
        )

        // When

        let request = MicropubRequestFactory.makeUploadRequest(
            media: media,
            mediaURL: mediaURL
        )

        // Then

        let formDataContent = String(
            data: try XCTUnwrap(request.body),
            encoding: .utf8
        )

        XCTAssertEqual(request.method, .post)
        XCTAssertEqual(request.baseURL?.absoluteString, "http://localhost/mediaUpload")
        XCTAssertNotNil(formDataContent)
    }
}

import Foundation
import MicroClient

public enum MicropubRequestFactory {

    /// Publish a new note/article.
    public static func makeNewPostRequest(
        name: String? = nil,
        summary: String? = nil,
        content: String,
        published: Date? = nil,
        updated: Date? = nil,
        categories: [String]? = nil,
        photoURL: URL? = nil,
        photoDescription: String? = nil,
        syndicateURL: URL? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        makeEntryRequest(
            name: name,
            summary: summary,
            content: content,
            published: published,
            updated: updated,
            categories: categories,
            photoURL: photoURL,
            photoDescription: photoDescription,
            syndicateURL: syndicateURL
        )
    }

    /// Publish a reply to a note/article.
    public static func makeReplyRequest(
        content: String,
        replyToURL: URL,
        syndicateURL: URL? = nil,
        published: Date? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        makeEntryRequest(
            content: content,
            published: published,
            syndicateURL: syndicateURL,
            replyURL: replyToURL
        )
    }

    /// Publish a repost.
    public static func makeRepostRequest(
        repostURL: URL?,
        categories: [String]? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        makeEntryRequest(
            categories: categories,
            repostURL: repostURL
        )
    }

    /// Publish a bookmark.
    public static func makeBookmarkRequest(
        name: String,
        content: String?,
        bookmarkURL: URL,
        categories: [String]? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        makeEntryRequest(
            name: name,
            content: content,
            categories: categories,
            bookmarkURL: bookmarkURL
        )
    }

    /// Retrieve the configuration.
    public static func makeConfigurationRequest(
    ) -> NetworkRequest<VoidRequest, ConfigurationResponse> {
        .init(
            path: "/micropub",
            method: .get,
            queryItems: [
                .init(name: "q", value: "config")
            ]
        )
    }

    /// Upload an image.
    public static func makeUploadRequest(
        media: Media,
        mediaURL: URL
    ) -> NetworkRequest<Data, VoidResponse> {
        let boundary = "MicroClient-\(UUID().uuidString)"

        return .init(
            method: .post,
            body: Data(
                media: media,
                boundary: boundary
            ),
            baseURL: mediaURL,
            additionalHeaders: [
                "Content-Type": "multipart/form-data; boundary=\(boundary)"
            ]
        )
    }

    public static func makeActionRequest(
        action: MicropubAction,
        url: URL
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/micropub",
            method: .post,
            formItems: [
                .init(name: "action", value: action.rawValue),
                .init(name: "url", value: url.absoluteString)
            ]
        )
    }

    // MARK: - Private

    private static func makeEntryRequest(
        name: String? = nil,
        summary: String? = nil,
        content: String? = nil,
        published: Date? = nil,
        updated: Date? = nil,
        categories: [String]? = nil,
        photoURL: URL? = nil,
        photoDescription: String? = nil,
        syndicateURL: URL? = nil,
        replyURL: URL? = nil,
        repostURL: URL? = nil,
        bookmarkURL: URL? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone.current

        return .init(
            path: "/micropub",
            method: .post,
            formItems: [
                .init(name: "h", value: "entry"),
                .init(name: "name", value: name),
                .init(name: "summary", value: summary),
                .init(name: "content", value: content),
                .init(name: "photo", value: photoURL?.absoluteString),
                .init(name: "mp-photo-alt", value: photoDescription),
                .init(name: "mp-syndicate-to", value: syndicateURL?.absoluteString),
                .init(name: "in-reply-to", value: replyURL?.absoluteString),
                .init(name: "repost-of", value: repostURL?.absoluteString),
                .init(name: "bookmark-of", value: bookmarkURL?.absoluteString),
                .init(name: "published", value: published.map(dateFormatter.string)),
                .init(name: "updated", value: updated.map(dateFormatter.string)),
            ].union(
                with: categories?.map { .init(name: "category[]", value: $0) }
            )
        )
    }
}

import Foundation

public struct ConfigurationResponse: Decodable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {
        case mediaEndpoint = "media-endpoint"
        case syndicateTo = "syndicate-to"
        case destination = "destination"
    }

    // MARK: - Properties

    public let mediaEndpoint: URL?
    public let syndicateTo: [SyndicateResponse]?
    public let destination: [DestinationResponse]?
}

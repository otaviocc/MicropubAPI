import Foundation

public struct ServiceResponse: Decodable {

    // MARK: - Nested types

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case photoURL = "photo"
    }

    // MARK: - Properties

    public let name: String
    public let url: URL
    public let photoURL: URL
}

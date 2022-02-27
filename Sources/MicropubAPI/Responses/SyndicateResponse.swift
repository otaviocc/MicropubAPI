import Foundation

public struct SyndicateResponse: Decodable {

    // MARK: - Properties

    public let uid: String
    public let name: String
    public let service: ServiceResponse?
    public let user: UserResponse?
}

import Foundation
import MicroClient

public protocol MicropubAPIFactoryProtocol {

    func makeMicropubAPIClient(
        baseURL: URL,
        authToken: @escaping () -> String?
    ) -> NetworkClientProtocol
}

public struct MicropubAPIFactory: MicropubAPIFactoryProtocol {

    // MARK: - Life cycle

    public init() {}

    // MARK: - Public

    public func makeMicropubAPIClient(
        baseURL: URL,
        authToken: @escaping () -> String?
    ) -> NetworkClientProtocol {
        let configuration = makeAPIConfiguration(
            baseURL: baseURL
        )

        configuration.interceptor = makeInterceptor(
            authToken: authToken
        )

        return NetworkClient(
            configuration: configuration
        )
    }
}

// MARK: - Private

private func makeAPIConfiguration(
    baseURL: URL
) -> NetworkConfiguration {
    .init(
        session: .shared,
        defaultDecoder: JSONDecoder(),
        defaultEncoder: JSONEncoder(),
        baseURL: baseURL
    )
}

private func makeInterceptor(
    authToken: @escaping () -> String?
) -> ((URLRequest) -> URLRequest)? {
    { request in
        var updatedRequest = request

        if let token = authToken() {
            updatedRequest.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }

        return updatedRequest
    }
}

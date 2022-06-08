public final class DataSourcesFactory {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    lazy var authenticationRemoteDataSource: AuthenticationRemoteDataSource = {
        .init(networkClient: networkClient)
    }()
}

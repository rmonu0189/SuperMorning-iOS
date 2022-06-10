public final class DataSourcesFactory {
    private let networkClient: NetworkClient
    private let userDefaultStorageService: UserDefaultStorageService

    public init(
        networkClient: NetworkClient,
        userDefaultStorageService: UserDefaultStorageService
    ) {
        self.networkClient = networkClient
        self.userDefaultStorageService = userDefaultStorageService
    }

    lazy var userSessionLocalDataSources: AppSession = {
        .init(service: userDefaultStorageService)
    }()

    lazy var authenticationRemoteDataSource: AuthenticationRemoteDataSource = {
        .init(networkClient: networkClient)
    }()
}

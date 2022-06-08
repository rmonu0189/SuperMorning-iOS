import CommonDomain

public final class RepositoryFactory: RepositoryFactoryProtocol {
    private let dataSourceFactory: DataSourcesFactory

    public init(dataSourceFactory: DataSourcesFactory) {
        self.dataSourceFactory = dataSourceFactory
    }

    public lazy var authenticationRepository: AuthenticationRepositoryProtocol = {
        AuthenticationRepository(remoteDataSource: dataSourceFactory.authenticationRemoteDataSource)
    }()
}

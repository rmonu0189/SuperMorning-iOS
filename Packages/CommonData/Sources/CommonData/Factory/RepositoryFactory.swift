import CommonDomain

public final class RepositoryFactory: RepositoryFactoryProtocol {
    private let dataSourceFactory: DataSourcesFactory
    private let appSession: AppSession

    public init(dataSourceFactory: DataSourcesFactory, appSession: AppSession) {
        self.dataSourceFactory = dataSourceFactory
        self.appSession = appSession
    }

    public lazy var authenticationRepository: AuthenticationRepositoryProtocol = {
        AuthenticationRepository(
            remoteDataSource: dataSourceFactory.authenticationRemoteDataSource,
            userRoleToDomainMapper: .init(),
            appSession: appSession
        )
    }()
}

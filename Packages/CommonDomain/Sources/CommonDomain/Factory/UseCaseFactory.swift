public final class UseCaseFactory {
    private let repositoryFactory: RepositoryFactoryProtocol

    public init(repositoryFactory: RepositoryFactoryProtocol) {
        self.repositoryFactory = repositoryFactory
    }
    
    public lazy var sendOneTimePasswordUseCase: SendOneTimePasswordUseCase = {
        .init(repository: repositoryFactory.authenticationRepository)
    }()
}

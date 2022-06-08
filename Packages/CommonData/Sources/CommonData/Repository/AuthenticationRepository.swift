import CommonDomain

class AuthenticationRepository: AuthenticationRepositoryProtocol {
    private let remoteDataSource: AuthenticationRemoteDataSource

    init(remoteDataSource: AuthenticationRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func sendOneTimePassword(
        with request: SendOneTimePasswordRequestDomainModel,
        success: @escaping (SendOneTimePasswordResponseDomainModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable {
        remoteDataSource.sendOneTimePassword(
            request: .init(phoneNumber: request.phoneNumber)
        ) { dataModel in
            success(.init(token: dataModel.token))
        } failed: { domainException in
            failed(domainException)
        }
    }
}

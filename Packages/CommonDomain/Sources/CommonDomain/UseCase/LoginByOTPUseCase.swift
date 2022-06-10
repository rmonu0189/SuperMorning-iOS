public class LoginByOTPUseCase: BaseUseCase<LoginByOTPRequestDomainModel, LoginResponseDomainModel> {
    let remoteRepository: AuthenticationRepositoryProtocol
    
    public init(repository: AuthenticationRepositoryProtocol) {
        self.remoteRepository = repository
    }

    public override func execute(input: Any?, callback: @escaping (UseCaseResult) -> Void) -> Cancellable? {
        guard let request = validateInput(value: input) else {
            callback(.failed(.useCaseInputError))
            return nil
        }
        return remoteRepository.loginByOneTimePassword(
            with: request
        ) { domainModel in
            callback(.success(domainModel))
        } failed: { domainException in
            callback(.failed(domainException))
        }
    }
}

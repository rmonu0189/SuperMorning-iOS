public protocol AuthenticationRepositoryProtocol {
    func sendOneTimePassword(
        with request: SendOneTimePasswordRequestDomainModel,
        success: @escaping (SendOneTimePasswordResponseDomainModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable

    func loginByOneTimePassword(
        with request: LoginByOTPRequestDomainModel,
        success: @escaping (LoginResponseDomainModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable
}

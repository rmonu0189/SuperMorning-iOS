public protocol AuthenticationRepositoryProtocol {
    func sendOneTimePassword(
        with request: SendOneTimePasswordRequestDomainModel,
        success: @escaping (SendOneTimePasswordResponseDomainModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable
}

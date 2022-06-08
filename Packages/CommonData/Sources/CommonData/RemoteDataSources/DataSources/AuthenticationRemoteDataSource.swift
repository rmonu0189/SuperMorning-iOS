import CommonDomain

class AuthenticationRemoteDataSource {
    let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func sendOneTimePassword(
        request: SendOneTimePasswordRequestModel,
        success: @escaping (SendOneTimePasswordResponseModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable {
        networkClient.performService(
            service: APIService.generateOTPForLogin,
            requestBody: .init(model: request)
        ) { (domainModel: SendOneTimePasswordResponseModel) in
            success(domainModel)
        } failed: { domainException in
            failed(domainException)
        }
    }

    func loginByOneTimePassword(
        request: LoginByOTPRequestModel,
        success: @escaping (LoginResponseModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable {
        networkClient.performService(
            service: APIService.loginByOTP,
            requestBody: .init(model: request)
        ) { (domainModel: LoginResponseModel) in
            success(domainModel)
        } failed: { domainException in
            failed(domainException)
        }
    }
}

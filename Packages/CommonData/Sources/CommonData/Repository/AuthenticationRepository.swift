import CommonDomain

class AuthenticationRepository: AuthenticationRepositoryProtocol {
    private let remoteDataSource: AuthenticationRemoteDataSource
    private let userRoleToDomainMapper: UserRoleToDomainMapper
    private let appSession: AppSession

    init(
        remoteDataSource: AuthenticationRemoteDataSource,
        userRoleToDomainMapper: UserRoleToDomainMapper,
        appSession: AppSession
    ) {
        self.remoteDataSource = remoteDataSource
        self.userRoleToDomainMapper = userRoleToDomainMapper
        self.appSession = appSession
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

    func loginByOneTimePassword(
        with request: LoginByOTPRequestDomainModel,
        success: @escaping (LoginResponseDomainModel) -> Void,
        failed: @escaping (DomainException) -> Void
    ) -> Cancellable {
        remoteDataSource.loginByOneTimePassword(
            request: .init(token: request.token, code: request.code)
        ) { [weak self] dataModel in
            self?.appSession.createSession(request: dataModel)
            success(.init(
                token: dataModel.token,
                profile: .init(
                    id: dataModel.profile.id,
                    firstName: dataModel.profile.firstName ?? "",
                    lastName: dataModel.profile.lastName ?? "",
                    phoneNumber: dataModel.profile.phoneNumber,
                    email: dataModel.profile.email ?? "",
                    profilePic: dataModel.profile.profilePic,
                    isDoorbell: dataModel.profile.isDoorbell,
                    isPushNotification: dataModel.profile.isPushNotification,
                    isProfileComplete: dataModel.profile.isProfileComplete,
                    roleLevel: self?.userRoleToDomainMapper.map(
                        input: dataModel.profile.roleLevel
                    ) ?? .user,
                    updatedAt: dataModel.profile.updatedAt,
                    createdAt: dataModel.profile.createdAt
                )
            ))
        } failed: { domainException in
            failed(domainException)
        }
    }
}

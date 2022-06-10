public struct LoginResponseDomainModel {
    public let token: String
    public let profile: ProfileDomainModel

    public init(token: String, profile: ProfileDomainModel) {
        self.token = token
        self.profile = profile
    }
}

public struct LoginByOTPRequestDomainModel {
    public let token: String
    public let code: String

    public init(token: String, code: String) {
        self.token = token
        self.code = code
    }
}

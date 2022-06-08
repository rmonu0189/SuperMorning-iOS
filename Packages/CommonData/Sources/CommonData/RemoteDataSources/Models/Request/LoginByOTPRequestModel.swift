struct LoginByOTPRequestModel: Codable {
    let token: String
    let code: String
}

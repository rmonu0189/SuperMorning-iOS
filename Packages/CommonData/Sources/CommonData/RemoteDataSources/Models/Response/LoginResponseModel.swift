struct LoginResponseModel: Codable {
    let token: String
    let profile: ProfileResponseModel
}

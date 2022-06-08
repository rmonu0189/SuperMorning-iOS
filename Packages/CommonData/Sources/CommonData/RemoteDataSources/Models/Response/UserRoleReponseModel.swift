enum UserRoleReponseModel: Int, Codable {
    case user = 1
    case subscribed = 10
    case staff = 512
    case manager = 1024
    case admin = 2048
}

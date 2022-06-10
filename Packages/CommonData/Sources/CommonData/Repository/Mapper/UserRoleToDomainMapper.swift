import CommonDomain

public class UserRoleToDomainMapper {
    public init() {}

    func map(input: UserRoleReponseModel) -> UserRoleDomainModel {
        switch input {
        case .user:
            return .user
        case .subscribed:
            return .subscribed
        case .staff:
            return .staff
        case .manager:
            return .manager
        case .admin:
            return .admin
        }
    }
}

import Foundation

public struct ProfileDomainModel {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let email: String
    public let profilePic: String?
    public let isDoorbell: Bool
    public let isPushNotification: Bool
    public let isProfileComplete: Bool
    public let roleLevel: UserRoleDomainModel
    public let updatedAt: Date?
    public let createdAt: Date

    public init(
        id: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        profilePic: String?,
        isDoorbell: Bool,
        isPushNotification: Bool,
        isProfileComplete: Bool,
        roleLevel: UserRoleDomainModel,
        updatedAt: Date?,
        createdAt: Date
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.profilePic = profilePic
        self.isDoorbell = isDoorbell
        self.isPushNotification = isPushNotification
        self.isProfileComplete = isProfileComplete
        self.roleLevel = roleLevel
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}

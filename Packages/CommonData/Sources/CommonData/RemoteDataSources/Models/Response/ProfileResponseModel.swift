import Foundation

struct ProfileResponseModel: Codable {
    let id: String
    let phoneNumber: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let profilePic: String?
    let roleLevel: UserRoleReponseModel
    let isPushNotification: Bool
    let isProfileComplete: Bool
    let isDoorbell: Bool
    let updatedAt: Date?
    let createdAt: Date
}

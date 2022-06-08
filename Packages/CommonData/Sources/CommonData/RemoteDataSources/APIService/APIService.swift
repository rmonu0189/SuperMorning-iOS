import Foundation

enum APIService: DPRequestProtocol {
    // MARK: - Authentication
    case generateOTPForLogin
    case loginByOTP
    case completeProfile
    case updateProfile
}

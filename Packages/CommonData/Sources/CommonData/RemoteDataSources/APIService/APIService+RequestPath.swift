import Foundation

extension APIService {
    func requestPath() -> DPRequestPath {
        switch self {
        case .generateOTPForLogin:
            return DPRequestPath(method: .POST, endPoint: "/v1/generateotp")
        case .loginByOTP:
            return DPRequestPath(method: .POST, endPoint: "/v1/loginbyotp")
        case .completeProfile:
            return DPRequestPath(method: .PUT, endPoint: "/v1/completeprofile")
        case .updateProfile:
            return DPRequestPath(method: .PUT, endPoint: "/v1/profile")
        }
    }
}

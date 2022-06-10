import Foundation
import CommonDomain

public class AppSession {
    private enum Constants {
        static let sessionKey = "session.user"
    }

    public let service: UserDefaultStorageService

    public init(service: UserDefaultStorageService) {
        self.service = service
    }

    var sessionToken: String? {
        let request: LoginResponseModel? = service.getObject(for: Constants.sessionKey)
        return request?.token
    }

    func createSession(request: LoginResponseModel) {
        service.setObject(request, for: Constants.sessionKey)
    }

    func clearSession() {
        service.remove(for: Constants.sessionKey)
    }

    func getSession() -> LoginResponseModel? {
        service.getObject(for: Constants.sessionKey)
    }
}

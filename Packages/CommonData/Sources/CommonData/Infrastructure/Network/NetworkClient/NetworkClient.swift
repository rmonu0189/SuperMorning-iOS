import CommonDomain
import Foundation

extension URLSessionTask: Cancellable {}

public class NetworkClient {
    private let appSession: AppSession
    private let connection: DPRequestConnection
    private let url: String

    public init(url: String, appSession: AppSession) {
        self.appSession = appSession
        self.url = url
        connection = .init(serverPath: nil)
    }

    private func getAuthorizationHeader() -> [String: String]? {
        if let token = appSession.sessionToken {
            return ["Authorization": "Bearer \(token)"]
        }
        return nil
    }

    func performService<T: Codable>(
        service: DPRequestProtocol,
        requestBody: DPRequestBody? = nil,
        success: ((T) -> Void)? = nil,
        failed: ((DomainException) -> Void)? = nil
    ) -> Cancellable {
        connection.performService(
            service,
            url: url,
            requestBody: requestBody,
            headers: getAuthorizationHeader()
        ) { response in
            if response.httpStatusCode.rawValue >= 500 {
                failed?(.serverError(message: response.httpStatusCode.statusDescription))
            } else if response.httpStatusCode == .cancelRequest {
                failed?(.cancelNetworkRequest)
            } else if response.httpStatusCode == .noInternetConnection {
                failed?(.noNetwork)
            } else if let error = response.error {
                let code = (error as NSError).code
                if code == DPHTTPStatusCode.noInternetConnection.rawValue || code == DPHTTPStatusCode.offline.rawValue {
                    failed?(.noNetwork)
                } else {
                    failed?(.serverError(message: error.localizedDescription))
                }
            } else if response.isSuccess == false {
                if let message = response.message {
                    failed?(.apiError(message: message))
                } else {
                    failed?(.somethingWentWrong)
                }
            } else {
                if let model = response.toModel(T.self) {
                    success?(model)
                } else {
                    failed?(.parsingError(message: "Failed to parse into \(T.self)"))
                }
            }
        }
    }
}

import Foundation

public final class DPRequestConnection {
    private let urlSession: URLSession
    private let serverPath: String?

    public init(serverPath: String?) {
        self.serverPath = serverPath
        urlSession = URLSession(configuration: DPRequestConnectionConfiguration.shared.configuration)
    }

    /**
     Perform request to fetch data
     - parameter request:           request
     - parameter userInfo:          userinfo
     - parameter completionHandler: handler
     */
    func performService(
        _ service: DPRequestProtocol,
        url: String? = nil,
        requestBody: DPRequestBody? = nil,
        completionHandler: @escaping (_ response: DPResponse) -> Void
    ) -> URLSessionDataTask {
        let request = service.prepareRequest(requestBody: requestBody, serverPath: url ?? serverPath)
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logResponse(response, data: data, error: error, inputBody: request.httpBody)
            let dataResponse = DPResponse(data: data, response: response, error: error, service: service)
            completionHandler(dataResponse)
        }
        task.resume()
        return task
    }

    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?, inputBody: Data?) {
        let path = response?.url?.absoluteString ?? ""
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let dataString = String(data: data ?? Data(), encoding: .utf8) ?? ""
        let inputString = String(data: inputBody ?? Data(), encoding: .utf8) ?? ""
        DPLogger.log("*************************************")
        DPLogger.log("Path:", path)
        DPLogger.log("Parameters:", inputString)
        DPLogger.log("Status Code:", statusCode)
        DPLogger.log("Response:", dataString)
        DPLogger.log("Error:", error ?? "N/A")
        DPLogger.log("*************************************")
    }
}

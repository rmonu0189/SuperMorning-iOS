import Foundation

extension DPRequestProtocol {
    func getURL(_ requestPath: DPRequestPath, baseURL: String?) -> URL {
        if let url = requestPath.url {
            return url
        } else if let baseURL = baseURL, let endPoint = requestPath.endPoint, let url = URL(string: baseURL + endPoint) {
            return url
        }
        fatalError("URL can not be nil.")
    }

    func prepareRequest(requestBody: DPRequestBody?, serverPath: String?) -> URLRequest {
        let requestPath = self.requestPath()
        var baseURL = baseUrl() ?? ""
        if let serverPath = serverPath {
            baseURL = serverPath + baseURL
        }
        var request = URLRequest(url: getURL(requestPath, baseURL: baseURL))
        request.timeoutInterval = DPRequestConnectionConfiguration.shared.timeoutInterval
        request.httpMethod = requestPath.method.rawValue
        var commonHeaders = commonHeaders()
        for (key, value) in requestBody?.headers ?? [:] {
            if let value = value as? String {
                commonHeaders[key] = value
            }
        }
        request.prepareHeaders(commonHeaders)
        if let body = requestBody {
            request.prepareBody(body, service: self)
        }
        return request
    }
}

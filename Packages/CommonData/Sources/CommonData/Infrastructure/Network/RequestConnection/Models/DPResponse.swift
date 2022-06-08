import Foundation

struct DPResponse {
    private var service: DPRequestProtocol
    var headers: [String: Any]?
    var url: URL?
    var result: Data?
    var httpStatusCode: DPHTTPStatusCode = .unknownStatus

    var isSuccess: Bool = false
    var error: Error?
    var message: String?

    init(data: Data?, response: URLResponse?, error: Error?, service: DPRequestProtocol) {
        result = data
        self.error = error
        url = response?.url
        self.service = service
        if let httpUrlResponse = response as? HTTPURLResponse {
            httpStatusCode = DPHTTPStatusCode(rawValue: httpUrlResponse.statusCode) ?? .unknownStatus
            headers = httpUrlResponse.allHeaderFields as? [String: Any]
        }
        if error == nil, let baseResponse = baseResponseModel(DPBaseAPIResponse.self) {
            isSuccess = baseResponse.status
            message = baseResponse.message
        } else if (error as NSError?)?.code == DPHTTPStatusCode.cancelRequest.rawValue {
            httpStatusCode = DPHTTPStatusCode.cancelRequest
        }
    }

    func decodeResponseToModel<T: Codable>(_ service: DPRequestProtocol, type _: T.Type) -> T? {
        if let key = service.responseKey() {
            let value = jsonResponse()[key]
            return decodeFromJSON(T.self, data: value, service: service)
        } else if let json = service.responseModelFromJSON(jsonResponse()) {
            return decodeFromJSON(T.self, data: json, service: service)
        } else if let json = service.responseModelFromData(result) {
            return decodeFromJSON(T.self, data: json, service: service)
        } else {
            return decodeFromJSON(T.self, data: jsonResponse(), service: service)
        }
    }

    func decodeResponseToModelList<T: Codable>(_ service: DPRequestProtocol, type _: T.Type) -> [T]? {
        if let key = service.responseKey() {
            let value = jsonResponse()[key]
            return decodeFromJSONList(T.self, data: value, service: service)
        } else if let json = service.responseModelFromJSON(jsonResponse()) {
            return decodeFromJSONList(T.self, data: json, service: service)
        } else if let json = service.responseModelFromData(result) {
            return decodeFromJSONList(T.self, data: json, service: service)
        } else if let json = jsonArrayResponse() {
            return decodeFromJSONList(T.self, data: json, service: service)
        } else {
            return decodeFromJSONList(T.self, data: jsonResponse(), service: service)
        }
    }

    func baseResponseModel<T: Codable>(_: T.Type) -> T? {
        return decodeFromJSON(T.self, data: jsonResponse(), service: service)
    }

    func toModel<T: Codable>(_: T.Type) -> T? {
        guard let key = service.responseKey() else { return nil }
        guard let jsonData = jsonResponse()[key] else { return nil }
        return decodeFromJSON(T.self, data: jsonData, service: nil)
    }

    public func toStringResult() -> String {
        String(data: result ?? Data(), encoding: .utf8) ?? ""
    }

    public func jsonResponse() -> [String: Any] {
        guard let data = result else { return [:] }
        do {
            let apiResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            return apiResponse ?? [:]
        } catch {
            DPLogger.log(error)
            return [:]
        }
    }

    private func jsonArrayResponse() -> [[String: Any]]? {
        guard let data = result else { return nil }
        do {
            let apiResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: Any]]
            return apiResponse
        } catch {
            DPLogger.log(error)
            return nil
        }
    }

    private func decodeFromJSON<T: Codable>(_: T.Type, data: Any?, service: DPRequestProtocol?) -> T? {
        do {
            guard let inputData = data else { return nil }
            let resultsData = try JSONSerialization.data(withJSONObject: inputData, options: .prettyPrinted)
            let decoder = JSONDecoder()
            if let strategy = service?.dateDecodingStrategy() {
                decoder.dateDecodingStrategy = strategy
            }
            return try decoder.decode(T.self, from: resultsData)
        } catch {
            DPLogger.log(error)
            return nil
        }
    }

    private func decodeFromJSONList<T: Codable>(_: T.Type, data: Any?, service: DPRequestProtocol) -> [T]? {
        do {
            guard let inputData = data else { return nil }
            let resultsData = try JSONSerialization.data(withJSONObject: inputData, options: .prettyPrinted)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let strategy = service.dateDecodingStrategy() {
                decoder.dateDecodingStrategy = strategy
            }
            return try decoder.decode([T].self, from: resultsData)
        } catch {
            DPLogger.log(error)
            return nil
        }
    }
}

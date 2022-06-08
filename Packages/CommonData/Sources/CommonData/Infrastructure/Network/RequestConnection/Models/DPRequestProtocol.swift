import Foundation

protocol DPRequestProtocol {
    func baseUrl() -> String?
    func requestPath() -> DPRequestPath
    func commonHeaders() -> [String: String]
    func responseKey() -> String?
    func responseModelFromJSON(_ json: [String: Any]) -> Any?
    func responseModelFromData(_ data: Data?) -> Any?
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy?
    func dateEncodingStrategy() -> JSONEncoder.DateEncodingStrategy?
}

extension DPRequestProtocol {
    func commonHeaders() -> [String: Any] { return [:] }
    func baseUrl() -> String? { return nil }
    func responseKey() -> String? { return nil }
    func responseModelFromJSON(_: [String: Any]) -> Any? { return nil }
    func responseModelFromData(_: Data?) -> Any? { return nil }
    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy? { return nil }
    func dateEncodingStrategy() -> JSONEncoder.DateEncodingStrategy? { return nil }
}

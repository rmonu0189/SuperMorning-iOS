import Foundation

struct DPRequestBody {
    var headers: [String: Any]?
    var model: Codable?
    var bodyInKeyValuePair: [String: Any]?
    var bodyEncodeType: DPRequestBodyEncodeType?
    var data: Data?
    var files: [String: Data]?
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy?
}

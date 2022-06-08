import Foundation

extension APIService {
    private struct Constants {
        static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        static let timeZone = "UTC"
    }

    func commonHeaders() -> [String : String] {
        return ["apikey": "xLKgzDut87hNOGQ001cHCVpw1y9o0vOvih8mQM0vY5vQczISlE"]
    }

    func responseKey() -> String? { "data" }

    func dateEncodingStrategy() -> JSONEncoder.DateEncodingStrategy? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.serverDateFormat
        formatter.timeZone = .init(identifier: Constants.timeZone)
        return .formatted(formatter)
    }

    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.serverDateFormat
        formatter.timeZone = .init(identifier: Constants.timeZone)
        return .formatted(formatter)
    }
}

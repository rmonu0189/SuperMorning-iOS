import Foundation

final class DPRequestConnectionConfiguration {
    fileprivate init() {}

    // Public Configurations
    var configuration = URLSessionConfiguration.default
    var authenticationTokenKeyInHeader: String?
    var isLogging: Bool = true
    var timeoutInterval: TimeInterval = 30

    // MARK: - Singleton Instance

    class var shared: DPRequestConnectionConfiguration {
        enum Singleton {
            static let instance = DPRequestConnectionConfiguration()
        }
        return Singleton.instance
    }
}

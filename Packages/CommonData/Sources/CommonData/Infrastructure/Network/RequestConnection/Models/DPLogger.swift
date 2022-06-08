import Foundation

struct DPLogger {
    static func log(_ message: Any...) {
        if DPRequestConnectionConfiguration.shared.isLogging {
            for item in message {
                print(item, separator: " ", terminator: " ")
            }
            print("")
        }
    }
}

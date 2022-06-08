import Foundation

public class UserDefaultStorageService {
    let userDefault: UserDefaults

    public init(userDefault: UserDefaults) {
        self.userDefault = userDefault
    }

    public func getValue(for key: String) -> Any? {
        userDefault.value(forKey: key)
    }

    public func setValue(_ value: String, for key: String) {
        userDefault.set(value, forKey: key)
    }
}

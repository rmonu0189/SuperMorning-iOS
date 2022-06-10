import Foundation

public class UserDefaultStorageService {
    let userDefault: UserDefaults

    public init(userDefault: UserDefaults) {
        self.userDefault = userDefault
    }

    public func getValue(for key: String) -> Any? {
        userDefault.value(forKey: key)
    }

    public func setValue(_ value: Any?, for key: String) {
        userDefault.set(value, forKey: key)
    }

    public func getObject<T: Codable>(for key: String) -> T? {
        guard let data = getValue(for: key) as? Data else { return nil }
        let object = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        return object as? T
    }

    public func setObject(_ object: Any, for key: String) {
        let data = try? JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
        setValue(data, for: key)
    }

    public func remove(for key: String) {
        if userDefault.value(forKey: key) != nil {
            userDefault.removeObject(forKey: key)
        }
    }
}

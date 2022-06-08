import Foundation

@propertyWrapper public struct UserDefaultStorage<Value> {
    let key: String

    public var wrappedValue: Value? {
        get { UserDefaults.standard.value(forKey: key) as? Value }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
}

@propertyWrapper public struct UserDefaultCustomStorage<Value: Codable> {
    let key: String
    public var wrappedValue: Value? {
        get {
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                let value = try? JSONDecoder().decode(Value.self, from: data)
                return value
            }
            return nil
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.setValue(data, forKey: key)
        }
    }
}

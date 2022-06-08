public class UserDefaultLocalDataSources {
    public init() {}

    @UserDefaultCustomStorage(key: "authorizationToken")
    public var authorizationToken: String?

}

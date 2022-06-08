public protocol GetStartedViewControllerFactoryProtocol {
    func makeGetStartedViewController() -> CoordinatedViewController & GetStartedActionable
}

final class GetStartedViewControllerFactory: GetStartedViewControllerFactoryProtocol {
    public func makeGetStartedViewController() -> CoordinatedViewController & GetStartedActionable {
        GetStartedViewController()
    }
}

public protocol VerifyOTPViewControllerFactoryProtocol {
    func makeVerifyOTPViewController() -> CoordinatedViewController & VerifyOTPActionable
}

final class VerifyOTPViewControllerFactory: VerifyOTPViewControllerFactoryProtocol {
    public func makeVerifyOTPViewController() -> CoordinatedViewController & VerifyOTPActionable {
        VerifyOTPViewController()
    }
}

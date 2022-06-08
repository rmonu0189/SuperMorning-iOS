public final class ViewControllerFactory {
    public init() {}

    public func phoneNumberViewControllerFactory() -> PhoneNumberViewControllerFactoryProtocol {
        PhoneNumberViewControllerFactory()
    }

    public func verifyOTPViewControllerFactory() -> VerifyOTPViewControllerFactoryProtocol {
        VerifyOTPViewControllerFactory()
    }

    public func getStartedViewControllerFactory() -> GetStartedViewControllerFactoryProtocol {
        GetStartedViewControllerFactory()
    }

    public func webViewControllerFactory() -> WebViewControllerFactoryProtocol {
        WebViewControllerFactory()
    }
}

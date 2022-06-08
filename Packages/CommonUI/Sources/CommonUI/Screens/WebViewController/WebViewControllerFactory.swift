public protocol WebViewControllerFactoryProtocol {
    func makeWebViewViewController(title: String, url: String) -> CoordinatedViewController & WebViewActionable
}

final class WebViewControllerFactory: WebViewControllerFactoryProtocol {
    public func makeWebViewViewController(
        title: String, url: String
    ) -> CoordinatedViewController & WebViewActionable {
        WebViewController(webTitle: title, url: url)
    }
}

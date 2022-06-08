import CommonUI

class WebViewCoordinator: BaseCoordinator {
    private let viewControllerFactory: WebViewControllerFactoryProtocol
    private let title: String
    private let url: String

    init(title: String, url: String, router: CoordinatedNavigationController) {
        viewControllerFactory = diContainer.viewControllerFactory.webViewControllerFactory()
        self.title = title
        self.url = url
        super.init(router: router)
    }

    override func start() {
        var controller = viewControllerFactory.makeWebViewViewController(
            title: title, url: url
        )
        controller.onBackAction = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        controller.onDestroy = onDestroy
        router.pushViewController(controller, animated: true)
    }
}

import CommonUI

class GetStartedCoordinator: BaseCoordinator {
    private let viewControllerFactory: GetStartedViewControllerFactoryProtocol

    override init(router: CoordinatedNavigationController) {
        viewControllerFactory = diContainer.viewControllerFactory.getStartedViewControllerFactory()
        super.init(router: router)
    }

    override func start() {
        var controller = viewControllerFactory.makeGetStartedViewController()
        controller.onGetStartedAction = { [weak self] in
            self?.startPhoneNumber()
        }
        controller.onDestroy = onDestroy
        router.changeRoot(with: controller)
    }

    private func startPhoneNumber() {
        let coordinator = PhoneNumberCoordinator(router: router)
        addChild(coordinator)
    }
}

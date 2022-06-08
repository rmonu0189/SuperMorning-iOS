import CommonUI

class VerifyOTPCoordinator: BaseCoordinator {
    private let viewControllerFactory: VerifyOTPViewControllerFactoryProtocol

    override init(router: CoordinatedNavigationController) {
        viewControllerFactory = diContainer.viewControllerFactory.verifyOTPViewControllerFactory()
        super.init(router: router)
    }

    override func start() {
        var controller = viewControllerFactory.makeVerifyOTPViewController()
        controller.onBackAction = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        controller.onVerifySuccessAction = { [weak self] in
            self?.startPhoneNumber()
        }
        controller.onDestroy = onDestroy
        router.pushViewController(controller, animated: true)
    }
    
    private func startPhoneNumber() {
        let coordinator = PhoneNumberCoordinator(router: router)
        addChild(coordinator)
    }
}

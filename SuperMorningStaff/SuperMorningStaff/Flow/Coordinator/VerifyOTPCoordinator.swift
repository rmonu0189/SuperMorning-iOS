import CommonUI
import CommonPresentation

class VerifyOTPCoordinator: BaseCoordinator {
    private let viewControllerFactory: VerifyOTPViewControllerFactoryProtocol
    private let phoneNumber: String
    private let otpToken: String

    init(router: CoordinatedNavigationController, phoneNumber: String, otpToken: String) {
        self.phoneNumber = phoneNumber
        self.otpToken = otpToken
        self.viewControllerFactory = diContainer.viewControllerFactory.verifyOTPViewControllerFactory()
        super.init(router: router)
    }

    override func start() {
        var controller = viewControllerFactory.makeVerifyOTPViewController(
            viewModel: VerifyOTPViewModel(
                useCaseExecutor: diContainer.useCaseExecutor,
                loginByOTPUseCase: diContainer.useCaseFactory.loginByOTPUseCase,
                otpToken: otpToken
            ),
            phoneNumber: phoneNumber
        )
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

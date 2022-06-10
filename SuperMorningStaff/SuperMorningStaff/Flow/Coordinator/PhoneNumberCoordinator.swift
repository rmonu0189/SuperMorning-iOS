import CommonUI
import CommonPresentation

class PhoneNumberCoordinator: BaseCoordinator {
    private let viewControllerFactory: PhoneNumberViewControllerFactoryProtocol

    override init(router: CoordinatedNavigationController) {
        viewControllerFactory = diContainer.viewControllerFactory.phoneNumberViewControllerFactory()
        super.init(router: router)
    }

    override func start() {
        var controller = viewControllerFactory.makePhoneNumberViewController(
            viewModel: PhoneNumberViewModel(
                useCaseExecutor: diContainer.useCaseExecutor,
                sendOneTimePasswordUseCase: diContainer.useCaseFactory.sendOneTimePasswordUseCase
            )
        )
        controller.onContinueAction = { [weak self] phoneNumber, token in
            self?.startVerifyOTP(with: phoneNumber, token: token)
        }
        controller.onBackAction = { [weak self] in
            self?.router.popViewController(animated: true)
        }
        controller.onTermsAndConditionAction = { [weak self] in
            self?.startTermsAndConditions()
        }
        controller.onDestroy = onDestroy
        router.pushViewController(controller, animated: true)
    }

    private func startVerifyOTP(with phoneNumber: String, token: String) {
        let coordinator = VerifyOTPCoordinator(
            router: router, phoneNumber: phoneNumber, otpToken: token
        )
        addChild(coordinator)
    }

    private func startTermsAndConditions() {
        let coordinator = WebViewCoordinator(
            title: "Terms & Conditions",
            url: "https://www.lipsum.com",
            router: router
        )
        addChild(coordinator)
    }
}

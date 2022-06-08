import CommonPresentation

public protocol PhoneNumberViewControllerFactoryProtocol {
    func makePhoneNumberViewController(
        viewModel: PhoneNumberViewModelProtocol
    ) -> CoordinatedViewController & PhoneNumberActionable
}

final class PhoneNumberViewControllerFactory: PhoneNumberViewControllerFactoryProtocol {
    public func makePhoneNumberViewController(
        viewModel: PhoneNumberViewModelProtocol
    ) -> CoordinatedViewController & PhoneNumberActionable {
        PhoneNumberViewController(viewModel: viewModel)
    }
}

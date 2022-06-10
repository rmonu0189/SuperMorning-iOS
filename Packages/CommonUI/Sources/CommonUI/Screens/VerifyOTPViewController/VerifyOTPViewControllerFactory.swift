import CommonPresentation

public protocol VerifyOTPViewControllerFactoryProtocol {
    func makeVerifyOTPViewController(
        viewModel: VerifyOTPViewModelProtocol,
        phoneNumber: String
    ) -> CoordinatedViewController & VerifyOTPActionable
}

final class VerifyOTPViewControllerFactory: VerifyOTPViewControllerFactoryProtocol {
    public func makeVerifyOTPViewController(
        viewModel: VerifyOTPViewModelProtocol,
        phoneNumber: String
    ) -> CoordinatedViewController & VerifyOTPActionable {
        VerifyOTPViewController(viewModel: viewModel, phoneNumber: phoneNumber)
    }
}

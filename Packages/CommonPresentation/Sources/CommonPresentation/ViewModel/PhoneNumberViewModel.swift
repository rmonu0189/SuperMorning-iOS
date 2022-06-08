import CommonDomain

public protocol PhoneNumberViewModelProtocol: BaseViewModelProtocol {
    var generateOneTimePassword: Bindable<String?> { get }

    func onSendOneTimePasswordAction(with phoneNumber: String)
}

public class PhoneNumberViewModel: BaseViewModel, PhoneNumberViewModelProtocol {
    public var generateOneTimePassword: Bindable<String?> = Bindable(nil)

    private let useCaseExecutor: UseCaseExecutor
    private let sendOneTimePasswordUseCase: SendOneTimePasswordUseCase
    private var phoneNumber: String

    public init(
        useCaseExecutor: UseCaseExecutor,
        sendOneTimePasswordUseCase: SendOneTimePasswordUseCase
    ) {
        self.useCaseExecutor = useCaseExecutor
        self.sendOneTimePasswordUseCase = sendOneTimePasswordUseCase
        self.phoneNumber = ""
    }

    public func onSendOneTimePasswordAction(with phoneNumber: String) {
        self.phoneNumber = phoneNumber
        executeSendOneTimePasswordUseCase()
    }

    private func executeSendOneTimePasswordUseCase() {
        showLoader?(true)
        let task = useCaseExecutor.execute(
            useCase: sendOneTimePasswordUseCase,
            input: SendOneTimePasswordRequestDomainModel(phoneNumber: phoneNumber)
        ) { [weak self] (domainModel: SendOneTimePasswordResponseDomainModel) in
            self?.generateOneTimePassword.update(with: domainModel.token)
            self?.showLoader?(false)
        } failed: { [weak self] domainException in
            self?.showException?(domainException)
            self?.showLoader?(false)
        }
        addTask(task)
    }
}

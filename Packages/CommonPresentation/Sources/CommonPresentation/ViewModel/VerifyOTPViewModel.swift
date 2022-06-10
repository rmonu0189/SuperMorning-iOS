import Foundation
import CommonDomain

public protocol VerifyOTPViewModelProtocol: BaseViewModelProtocol {
    var resendOTPTimerInSecond: Bindable<Int> { get }
    var loginSuccess: Bindable<Bool> { get }

    func onSubmitAction(with otp: String)
    func onResendOTPAction()
}

public class VerifyOTPViewModel: BaseViewModel, VerifyOTPViewModelProtocol {
    public var resendOTPTimerInSecond: Bindable<Int> = Bindable(31)
    public var loginSuccess: Bindable<Bool> = Bindable(false)

    private let useCaseExecutor: UseCaseExecutor
    private let loginByOTPUseCase: LoginByOTPUseCase
    private let otpToken: String

    private var timer: Timer?

    public init(
        useCaseExecutor: UseCaseExecutor,
        loginByOTPUseCase: LoginByOTPUseCase,
        otpToken: String
    ) {
        self.useCaseExecutor = useCaseExecutor
        self.loginByOTPUseCase = loginByOTPUseCase
        self.otpToken = otpToken
        super.init()
        scheduleTimer()
    }

    public func onSubmitAction(with otp: String) {
        executeLoginByOTPUseCase(with: otp)
    }

    public func onResendOTPAction() {
        stopTimer()
        resendOTPTimerInSecond.update(with: 30)
        scheduleTimer()
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0, repeats: true,
            block: { [weak self] _ in
                let seconds = (self?.resendOTPTimerInSecond.value ?? 0) - 1
                self?.resendOTPTimerInSecond.update(with: seconds)
                if seconds == 0 {
                    self?.stopTimer()
                }
            }
        )
    }

    private func stopTimer() {
        if timer?.isValid == true { timer?.invalidate() }
        timer = nil
    }

    private func executeLoginByOTPUseCase(with code: String) {
        showLoader?(true)
        let task = useCaseExecutor.execute(
            useCase: loginByOTPUseCase,
            input: LoginByOTPRequestDomainModel(token: otpToken, code: code)
        ) { [weak self] (domainModel: LoginResponseDomainModel) in
            self?.showLoader?(false)
            self?.loginSuccess.update(with: true)
        } failed: { [weak self] domainException in
            self?.showException?(domainException)
            self?.showLoader?(false)
        }
        addTask(task)
    }
}

import UIKit
import CommonPresentation

public class VerifyOTPViewController: BaseViewController, VerifyOTPActionable {
    private enum Constants {
        static let passcodeLength: Int8 = 6
        static let animationDuration: CGFloat = 0.3
        static let horizontalInset: CGFloat = 16
        static let passcodeTopInset: CGFloat = 20
        static let headerImage: String = "enterMobileTopIcon"
    }

    private let viewModel: VerifyOTPViewModelProtocol
    private let phoneNumber: String

    private var headerView: HeaderView!
    private var continueButton: CTAButtonView!
    private var messageLabel: StyleLabel!
    private var passcodeView: PasscodeView!
    private var resendOtpLabel: StyleLabel!
    private var continueButtonBottomConstraint: NSLayoutConstraint!

    public var onBackAction: (() -> Void)?
    public var onVerifySuccessAction: (() -> Void)?

    public init(viewModel: VerifyOTPViewModelProtocol, phoneNumber: String) {
        self.viewModel = viewModel
        self.phoneNumber = phoneNumber
        super.init(viewModel: viewModel)
        initializeUI()
        addConstraints()
        listenKeyboardNotification()
        bindKeyboardListeners()
        addKeypadDissmissTapGesture()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        viewModel.resendOTPTimerInSecond.bind { [weak self] seconds in
            self?.refreshResendOTPLabel(for: seconds)
        }
        viewModel.loginSuccess.bind { [weak self] status in
            guard status else { return }
            self?.onVerifySuccessAction?()
        }
    }

    private func bindKeyboardListeners() {
        keyboardWillShow = { [weak self] height in
            self?.headerView.isLarge = false
            UIView.animate(withDuration: Constants.animationDuration) {
                self?.continueButtonBottomConstraint.constant = -(height - (self?.safeAreaInsets.bottom ?? .zero))
                self?.view.layoutIfNeeded()
            }
        }
        keyboardWillHide = { [weak self] in
            self?.headerView.isLarge = true
            self?.continueButtonBottomConstraint.constant = .zero
            self?.view.layoutIfNeeded()
        }
    }

    private func refreshResendOTPLabel(for seconds: Int) {
        if seconds == 0 {
            resendOtpLabel.text = "Click here to resend code"
            resendOtpLabel.addLinks(for: [
                .init(
                    text: "Click here to resend code",
                    attribute: .init(
                        font: FontStyle.heading3.font,
                        color: .styleButtonBackground,
                        isUnderline: true
                    ),
                    callback: { [weak self] in
                        self?.viewModel.onResendOTPAction()
                    }
                )
            ])
        } else {
            resendOtpLabel.attributedText = nil
            let time = String(format: "00:%02d", seconds)
            resendOtpLabel.text = String(
                format: InheritedResource.localizedString(
                    key: "verify_otp_resend_code_in_time",
                    defaultValue: "Resend code in %@"
                ), time
            )
            resendOtpLabel.addLinks(for: [
                .init(
                    text: time,
                    attribute: .init(
                        font: FontStyle.heading3.font,
                        color: .styleButtonBackground
                    ),
                    callback: nil
                )
            ])
        }
    }
}

extension VerifyOTPViewController {
    private func initializeUI() {
        headerView = .init(
            uiModel: .init(
                title: InheritedResource.localizedString(
                    key: "verify_otp_title",
                    defaultValue: "Verify Mobile Number"
                ),
                imageName: Constants.headerImage
            ),
            backButtonHandler: { [weak self] in
                self?.onBackAction?()
            }
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let phoneWithCode = "+91-\(phoneNumber)"
        messageLabel = .init(style: .subtitle, color: .styleTextGrey)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = String(
            format: InheritedResource.localizedString(
                key: "verify_otp_message_label",
                defaultValue: "We have sent a 6 digit OTP to %@ "
            ),
            phoneWithCode
        )
        messageLabel.addLinks(for: [
            .init(
                text: phoneWithCode,
                attribute: .init(
                    font: FontStyle.subtitleBold.font,
                    color: .styleButtonBackground,
                    isUnderline: true
                ),
                callback: { [weak self] in
                    self?.onBackAction?()
                }
            )
        ])
        view.addSubview(messageLabel)

        passcodeView = .init(length: Constants.passcodeLength)
        passcodeView.translatesAutoresizingMaskIntoConstraints = false
        passcodeView.passcodeInputDidChange = { [weak self] passcode in
            self?.continueButton.isEnable = passcode.count == Constants.passcodeLength
        }
        view.addSubview(passcodeView)

        resendOtpLabel = .init(style: .heading3, color: .styleTextDark)
        resendOtpLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resendOtpLabel)

        continueButton = .init(
            title: InheritedResource.localizedString(
                key: "continue",
                defaultValue: "CONTINUE"
            ),
            action: { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.onSubmitAction(with: self.passcodeView.passcode)
            }
        )
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
    }

    private func addConstraints(){
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.horizontalInset
            ),
            messageLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Constants.horizontalInset
            )
        ])

        NSLayoutConstraint.activate([
            passcodeView.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor, constant: Constants.passcodeTopInset
            ),
            passcodeView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Constants.horizontalInset
            )
        ])

        NSLayoutConstraint.activate([
            resendOtpLabel.topAnchor.constraint(
                equalTo: passcodeView.bottomAnchor, constant: Constants.passcodeTopInset
            ),
            resendOtpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset)
        ])

        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        continueButtonBottomConstraint = continueButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
        continueButtonBottomConstraint.isActive = true
    }
}

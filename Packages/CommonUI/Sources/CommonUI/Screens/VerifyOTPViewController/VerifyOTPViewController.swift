import UIKit

public class VerifyOTPViewController: BaseViewController, VerifyOTPActionable {
    private enum Constants {
        static let passcodeLength: Int8 = 4
        static let animationDuration: CGFloat = 0.3
    }

    private var headerView: HeaderView!
    private var continueButton: CTAButtonView!
    private var messageLabel: StyleLabel!
    private var passcodeView: PasscodeView!
    private var continueButtonBottomConstraint: NSLayoutConstraint!

    public var onBackAction: (() -> Void)?
    public var onVerifySuccessAction: (() -> Void)?

    public init() {
        super.init()
        initializeUI()
        addConstraints()
        listenKeyboardNotification()
        bindKeyboardListeners()
        addKeypadDissmissTapGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

extension VerifyOTPViewController {
    private func initializeUI() {
        headerView = .init(
            uiModel: .init(
                title: InheritedResource.localizedString(
                    key: "verify_otp_title",
                    defaultValue: "Verify Mobile Number Default"
                ),
                imageName: "enterMobileTopIcon"
            ),
            backButtonHandler: { [weak self] in
                self?.onBackAction?()
            }
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let phoneWithCode = "+91-9109322140"
        messageLabel = .init(style: .subtitle, color: .styleTextGrey)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "We have sent a 4 digit OTP to \(phoneWithCode) "
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

        continueButton = .init(title: "CONTINUE", action: { [weak self] in
            self?.onVerifySuccessAction?()
        })
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
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            passcodeView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            passcodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
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

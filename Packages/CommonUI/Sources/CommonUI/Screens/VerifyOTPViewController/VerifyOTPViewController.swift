import UIKit

public class VerifyOTPViewController: BaseViewController, VerifyOTPActionable {
    private var headerView: HeaderView!
    private var continueButton: CTAButtonView!
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
            UIView.animate(withDuration: 0.3) {
                self?.continueButtonBottomConstraint.constant = -(height - (self?.safeAreaInsets.bottom ?? 0))
                self?.view.layoutIfNeeded()
            }
        }
        keyboardWillHide = { [weak self] in
            self?.headerView.isLarge = true
            self?.continueButtonBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        }
    }
}

extension VerifyOTPViewController {
    private func initializeUI() {
        headerView = .init(
            uiModel: .init(
                title: "Verify Mobile Number",
                imageName: "enterMobileTopIcon"
            ),
            backButtonHandler: { [weak self] in
                self?.onBackAction?()
            }
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

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
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        continueButtonBottomConstraint = continueButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
        continueButtonBottomConstraint.isActive = true
    }
}

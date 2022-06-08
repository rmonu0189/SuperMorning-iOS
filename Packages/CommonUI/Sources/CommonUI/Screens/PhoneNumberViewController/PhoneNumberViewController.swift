import UIKit
import CommonPresentation

public class PhoneNumberViewController: BaseViewController, PhoneNumberActionable {
    private var headerView: HeaderView!
    private var phoneTextField: PhoneNumberTextField!
    private var continueButton: CTAButtonView!
    private var termsConditionLabel: StyleLabel!
    private var continueButtonBottomConstraint: NSLayoutConstraint!

    private let viewModel: PhoneNumberViewModelProtocol

    public var onBackAction: (() -> Void)?
    public var onTermsAndConditionAction: (() -> Void)?
    public var onContinueAction: ((String, String) -> Void)?

    public init(viewModel: PhoneNumberViewModelProtocol) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
        initializeUI()
        addConstraints()
        bindViewModel()
        listenKeyboardNotification()
        bindKeyboardListeners()
        addKeypadDissmissTapGesture()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.cancelAllTask()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.generateOneTimePassword.bind { [weak self] token in
            guard let token = token else { return }
            guard let phoneNumber = self?.phoneTextField.trimText else { return }
            self?.onContinueAction?(phoneNumber, token)
        }
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

extension PhoneNumberViewController {
    private func initializeUI() {
        headerView = .init(
            uiModel: .init(
                title: "Signup/Login to join Us",
                imageName: "enterMobileTopIcon"
            ),
            backButtonHandler: { [weak self] in
                self?.onBackAction?()
            }
        )
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        phoneTextField = .init(
            style: .heading2,
            placeholder: "Enter Your Phone number"
        )
        phoneTextField.keyboardType = .phonePad
        phoneTextField.tintColor = .styleTextGrey
        phoneTextField.textColor = .styleTextDark
        phoneTextField.placeholderStyle = .heading2
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.editingDidBegin = { [weak self] in
            self?.headerView.isLarge = false
        }
        phoneTextField.editingDidEnd = { [weak self] in
            self?.headerView.isLarge = true
        }
        phoneTextField.checkFieldValidation = { [weak self] (isValid, _) in
            self?.continueButton.isEnable = isValid
        }
        view.addSubview(phoneTextField)

        continueButton = .init(title: "CONTINUE", action: { [weak self] in
            guard let phoneNumber = self?.phoneTextField.trimText else  { return }
            self?.view.endEditing(true)
            self?.viewModel.onSendOneTimePasswordAction(with: phoneNumber)
        })
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)

        termsConditionLabel = .init(style: .subtitle, color: .styleTextGrey)
        termsConditionLabel.text = "By clicking 'CONTINUE', you agree to our \n TERMS AND CONDITIONS "
        termsConditionLabel.addLinks(for: [
            .init(
                text: "TERMS AND CONDITIONS",
                attribute: .init(
                    font: FontStyle.subtitle.font,
                    color: .styleButtonBackground,
                    isUnderline: true
                ),
                callback: { [weak self] in
                    self?.onTermsAndConditionAction?()
                }
            )
        ])
        termsConditionLabel.textAlignment = .center
        termsConditionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsConditionLabel)
    }

    private func addConstraints(){
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 56)
        ])

        NSLayoutConstraint.activate([
            termsConditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            termsConditionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            termsConditionLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16)
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

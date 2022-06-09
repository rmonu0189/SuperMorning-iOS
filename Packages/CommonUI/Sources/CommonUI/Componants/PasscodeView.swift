import UIKit

class PasscodeView: UIView {
    private var stackView: UIStackView!
    private var labels: [UILabel] = []
    private var inputTextField: UITextField!
    private var inputButton: UIButton!

    public var passcodeInputDidBegin: (() -> Void)?
    public var passcodeInputDidEnd: (() -> Void)?
    public var passcodeInputDidChange: ((String) -> Void)?

    public var passcode: String {
        var value = ""
        _ = labels.map { label in
            value += (label.text ?? "")
        }
        return value
    }

    init(length: Int8) {
        super.init(frame: .zero)
        initializeUI(length: length)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setError(_ isError: Bool) {
        _ = labels.map { label in
            label.backgroundColor = isError ? .styleErrorBackground : .styleButtonDisable
        }
    }

    @objc private func inputDidBegin() {
        inputTextField.becomeFirstResponder()
    }
}

extension PasscodeView {
    private func initializeUI(length: Int8) {
        stackView = .init(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        for _ in 0 ..< length {
            let label = UILabel(frame: .zero)
            label.font = FontStyle.heading2.font
            label.textColor = .black
            label.backgroundColor = .styleButtonDisable
            label.cornerRadius = 8
            label.clipsToBounds = true
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 40),
                label.heightAnchor.constraint(equalToConstant: 40),
            ])
            labels.append(label)
            stackView.addArrangedSubview(label)
        }

        inputTextField = .init(frame: .zero)
        inputTextField.tintColor = .clear
        inputTextField.textColor = .clear
        inputTextField.keyboardType = .numberPad
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(didChnageText(_:)), for: .editingChanged)
        addSubview(inputTextField)

        inputButton = .init(frame: .zero)
        inputButton.addTarget(self, action: #selector(inputDidBegin), for: .touchUpInside)
        inputButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            inputButton.topAnchor.constraint(equalTo: topAnchor),
            inputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension PasscodeView: UITextFieldDelegate {
    private func clearAllLabel() {
        _ = labels.map { label in
            label.text = ""
            label.backgroundColor = .styleButtonDisable
        }
    }

    private func nextLabel() -> UILabel? {
        for label in labels {
            if label.text?.count ?? 0 <= 0 {
                return label
            }
        }
        return nil
    }

    @objc private func didChnageText(_ textField: UITextField) {
        clearAllLabel()
        let text = textField.text ?? ""
        for item in text {
            nextLabel()?.text = String(item)
        }
        textField.text = passcode
        passcodeInputDidChange?(passcode)
    }

    func textFieldDidBeginEditing(_: UITextField) {
        passcodeInputDidBegin?()
    }

    func textFieldDidEndEditing(_: UITextField) {
        passcodeInputDidEnd?()
    }
}

import UIKit

class StyleTextField: UITextField {
    enum FieldType {
        case none
        case mobile
        case email
    }

    public var leftPadding: CGFloat { 24 }
    public var maxLength: Int? { nil }
    private var placeholderLabel: StyleLabel!
    private var placeholderLeftConstraint: NSLayoutConstraint!
    private var placeholderCenterConstraint: NSLayoutConstraint!
    private var placeholderTopConstraint: NSLayoutConstraint!
    private var borderLayer: CAShapeLayer!

    public let style: FontStyle
    public var fieldType: FieldType { .none }
    public var editingDidBegin: (() -> Void)?
    public var editingDidEnd: (() -> Void)?
    public var checkFieldValidation: ((Bool, Error?) -> Void)?

    override var text: String? {
        didSet {
            movePlaceholder(isTop: text?.count != 0)
        }
    }
    
    var placeholderStyle: FontStyle? {
        didSet {
            placeholderLabel.font = placeholderStyle?.font
        }
    }

    init(style: FontStyle, placeholder: String) {
        self.style = style
        super.init(frame: .zero)
        initializeUI(placeholder: placeholder)
        addConstraints()
        setupNotifications()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
    }

    public func setRightIcon(_ image: UIImage?) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.frame = .init(x: 0, y: 0, width: 24, height: 24)
        let view = UIView(frame: .init(x: 0, y: 0, width: 50, height: frame.height))
        imageView.center = view.center
        view.addSubview(imageView)
        rightView = view
        rightViewMode = .always
    }

    func movePlaceholder(isTop: Bool) {
        let placeholderStyle = placeholderStyle ?? style
        if isTop {
            placeholderLabel.font = UIFont(name: placeholderStyle.fontName, size: 12)
            placeholderCenterConstraint.isActive = false
            placeholderTopConstraint.isActive = true
            placeholderLeftConstraint.constant = 14
        } else {
            placeholderLabel.font = placeholderStyle.font
            placeholderCenterConstraint.isActive = true
            placeholderTopConstraint.isActive = false
            placeholderLeftConstraint.constant = 20
        }
    }

    func initializeUI(placeholder: String) {
        font = style.font
        cornerRadius = 12
        backgroundColor = .white
        borderStyle = .none

        borderLayer = .init()
        borderLayer.cornerRadius = 12
        borderLayer.borderColor = UIColor.styleBorderGray.cgColor
        borderLayer.borderWidth = 2
        layer.addSublayer(borderLayer)

        placeholderLabel = .init(style: style)
        placeholderLabel.textColor = .styleTextGrey
        placeholderLabel.text = " \(placeholder) "
        placeholderLabel.backgroundColor = backgroundColor
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
    }

    func addConstraints() {
        placeholderLeftConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: -8)
        placeholderCenterConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        placeholderCenterConstraint.isActive = true
        placeholderTopConstraint.isActive = false
        placeholderLeftConstraint.isActive = true
    }

    private func validateFields() {
        guard fieldType != .none else { return }
        do {
            if fieldType == .mobile {
                try trimText.requiredValidation(message: "")
                try trimText.mobileNumberValidation(message: "Please enter 10 digits of your mobile number")
            }
            checkFieldValidation?(true, nil)
        } catch {
            checkFieldValidation?(false, error)
        }
    }
}

extension StyleTextField {
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 5))
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 5))
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 5))
    }
}

extension StyleTextField {
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(StyleTextField.textFieldDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(StyleTextField.textFiledDidEndEditing(_:)), name: UITextField.textDidEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(StyleTextField.textDidChange(_:)), name: UITextField.textDidChangeNotification, object: self)
    }

    @objc func textFieldDidBeginEditing(_: Notification) {
        editingDidBegin?()
        UIView.animate(withDuration: 0.3) {
            self.movePlaceholder(isTop: true)
        }
    }

    @objc func textFiledDidEndEditing(_: Notification?) {
        editingDidEnd?()
        guard text?.count ?? 0 <= 0 else { return }
        UIView.animate(withDuration: 0.3) {
            self.movePlaceholder(isTop: false)
        }
    }

    @objc func textDidChange(_: Notification?) {
        if let maxLength = maxLength, maxLength > 0 {
            if (self.text?.count ?? 0) > maxLength {
                self.text = String(self.text?.prefix(maxLength) ?? "")
            }
        }
        validateFields()
    }
}

import UIKit

class PhoneNumberTextField: StyleTextField {
    override var leftPadding: CGFloat { 65 }
    override var maxLength: Int? { 10 }
    private var countryCodeLabel: StyleLabel!
    override var fieldType: StyleTextField.FieldType { .mobile }

    override func initializeUI(placeholder: String) {
        super.initializeUI(placeholder: placeholder)

        countryCodeLabel = .init(style: style, color: .styleTextDark)
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.text = "+91 - "
        leftView = countryCodeLabel
        leftViewMode = .always
        countryCodeLabel.isHidden = true
    }

    override func addConstraints() {
        super.addConstraints()

        NSLayoutConstraint.activate([
            countryCodeLabel.widthAnchor.constraint(equalToConstant: 60),
        ])
    }

    override func movePlaceholder(isTop: Bool) {
        super.movePlaceholder(isTop: isTop)
        if isTop {
            countryCodeLabel.isHidden = false
        } else if text?.count ?? 0 <= 0 {
            countryCodeLabel.isHidden = true
        }
    }
}

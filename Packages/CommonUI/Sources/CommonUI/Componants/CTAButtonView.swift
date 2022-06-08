import UIKit

public class CTAButtonView: UIView {
    private var action: (() -> Void)?
    private var button: StyleButton!
    private var horizontalLine: UIView!

    public var isEnable: Bool = false {
        didSet {
            button.isEnabled = isEnable
        }
    }

    public init(title: String, action: (() -> Void)?) {
        self.action = action
        super.init(frame: .zero)
        initializeUI(title: title)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func didTapAction() {
        action?()
    }
}

extension CTAButtonView {
    private func initializeUI(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        button = .init(backgroundColor: .styleButtonBackground)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 24
        button.titleLabel?.font = FontStyle.heading3.font
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        button.setTitleColor(.styleTextGrey, for: .disabled)
        addSubview(button)

        horizontalLine = .init(frame: .zero)
        horizontalLine.backgroundColor = .styleButtonDisable
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalLine)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            horizontalLine.topAnchor.constraint(equalTo: topAnchor),
            horizontalLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalLine.heightAnchor.constraint(equalToConstant: 1),
        ])

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 8),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

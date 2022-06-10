import UIKit
import CommonDomain

public class ToasMessageView: UIView {
    private var iconImageView: UIImageView!
    private var messageLabel: UILabel!

    public init() {
        super.init(frame: .zero)
        initializeUI()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup(with uiModel: UiModel) {
        iconImageView.image = uiModel.icon
        iconImageView.tintColor = uiModel.iconColor
        messageLabel.text = uiModel.message
        backgroundColor = uiModel.backgroundColor
    }
}

public extension ToasMessageView {
    struct UiModel {
        let message: String
        let icon: UIImage?
        let iconColor: UIColor?
        let backgroundColor: UIColor?
    }

    @objc private func closeTapped() {
        removeFromSuperview()
    }
}

extension ToasMessageView {
    private func initializeUI() {
        cornerRadius = 12
        backgroundColor = .green

        iconImageView = .init(frame: .zero)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)

        messageLabel = .init(frame: .zero)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 14)
        addSubview(messageLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        addGestureRecognizer(tapGesture)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

extension ToasMessageView {
    public static func show(exception: DomainException) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let toast = ToasMessageView()
        toast.translatesAutoresizingMaskIntoConstraints = false
        switch exception {
        case .noNetwork:
            toast.setup(with: .init(
                message: "Please check your internet connection...",
                icon: UIImage(systemName: "antenna.radiowaves.left.and.right.slash"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .apiError(let message):
            toast.setup(with: .init(
                message: message,
                icon: UIImage(systemName: "xmark.icloud"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .useCaseInputError:
            toast.setup(with: .init(
                message: "Invalid input values for UseCase.",
                icon: UIImage(systemName: "xmark.icloud"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .serverError(let message):
            toast.setup(with: .init(
                message: message,
                icon: UIImage(systemName: "xserve"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .parsingError(let message):
            toast.setup(with: .init(
                message: message,
                icon: UIImage(systemName: "bolt.slash"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .somethingWentWrong:
            toast.setup(with: .init(
                message: "Something went wrong.",
                icon: UIImage(systemName: "bolt.slash"),
                iconColor: .white,
                backgroundColor: .red
            ))
        case .genric(let message):
            toast.setup(with: .init(
                message: message,
                icon: UIImage(systemName: "checkmark.circle"),
                iconColor: .white,
                backgroundColor: .green
            ))
        case .cancelNetworkRequest, .noSession:
            break
        }

        window.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 12),
            toast.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -12)
        ])

        let topConstraint = toast.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: -200)
        topConstraint.isActive = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.3) {
                topConstraint.constant = 0
                window.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 5.0) {
                    topConstraint.constant = -200
                    window.layoutIfNeeded()
                } completion: { _ in
                    toast.removeFromSuperview()
                }
            }
        }
    }
}

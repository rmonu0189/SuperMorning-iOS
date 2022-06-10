import UIKit

public class HeaderView: UIView {
    private var topSafeArea: CGFloat {
        UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }

    private var activityIndicator: UIActivityIndicatorView!
    private var imageView: UIImageView!
    private var backButton: StyleButton!
    private var titleLabel: StyleLabel!
    private var titleTopConstraint: NSLayoutConstraint!
    private var titleLeadingConstraint: NSLayoutConstraint!
    private var backButtonHandler: (() -> Void)?

    public var isLarge: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.imageView.isHidden = !self.isLarge
                self.titleTopConstraint.constant = self.isLarge ? 123 : -24
                self.titleLeadingConstraint.constant = self.isLarge ? 16 : 48
            }
        }
    }

    public init(uiModel: UiModel, backButtonHandler: (() -> Void)?) {
        self.backButtonHandler = backButtonHandler
        super.init(frame: .zero)
        initializeUI(uiModel: uiModel)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func goBack() {
        backButtonHandler?()
    }

    public func startLoading() {
        activityIndicator.startAnimating()
    }

    public func stopLoading() {
        activityIndicator.stopAnimating()
    }
}

extension HeaderView {
    private func initializeUI(uiModel: UiModel) {
        translatesAutoresizingMaskIntoConstraints = false

        imageView = .init(image: InheritedResource.image(uiModel.imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        backButton = .init(backgroundColor: .clear)
        backButton.setImage(InheritedResource.image("backArrowBlack"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        addSubview(backButton)

        titleLabel = .init(style: .heading2, color: .styleTextDark)
        titleLabel.text = uiModel.title
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        activityIndicator = .init(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 192),
        ])

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: topSafeArea + 5),
        ])

        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: backButton.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 123)
        titleLeadingConstraint.isActive = true
        titleTopConstraint.isActive = true
    }
}

public extension HeaderView {
    struct UiModel {
        let title: String
        let imageName: String
    }
}

import UIKit

public class GetStartedViewController: BaseViewController, GetStartedActionable {
    private var getStartedButton: CTAButtonView!

    public var onGetStartedAction: (() -> Void)?

    public init() {
        super.init()
        initializeUI()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GetStartedViewController {
    private func initializeUI() {
        getStartedButton = .init(title: "Get Started", action: { [weak self] in
            self?.onGetStartedAction?()
        })
        getStartedButton.isEnable = true
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(getStartedButton)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            getStartedButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
}

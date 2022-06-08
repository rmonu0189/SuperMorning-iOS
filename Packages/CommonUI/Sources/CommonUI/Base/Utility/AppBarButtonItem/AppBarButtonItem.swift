import UIKit

public class AppBarButtonItem: UIBarButtonItem {
    private var actionHandler: (() -> Void)? = nil

    public init(title: String, actionHandler: (() -> Void)?) {
        self.actionHandler = actionHandler
        super.init()
        self.title = title
        self.style = .plain
        self.target = self
        self.action = #selector(didTapAction)
    }

    public init(icon: UIImage?, actionHandler: (() -> Void)?) {
        self.actionHandler = actionHandler
        super.init()
        self.image = icon
        self.style = .plain
        self.target = self
        self.action = #selector(didTapAction)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapAction() {
        actionHandler?()
    }
}

import UIKit

open class CoordinatedNavigationController: UINavigationController {
    public var onPopController: (() -> Void)?
    public var onPopToRootController: (() -> Void)?
    public var childCoordinators: [Coordinator] = []

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = false
        navigationBarAppearance()
    }

    @discardableResult
    override open func popViewController(animated: Bool) -> UIViewController? {
        onPopController?()
        return super.popViewController(animated: animated)
    }

    @discardableResult
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        onPopToRootController?()
        return super.popToRootViewController(animated: animated)
    }

    public func changeRoot(with controller: UIViewController) {
        viewControllers = [controller]
    }

    private func navigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        navigationBar.scrollEdgeAppearance = appearance
    }
}

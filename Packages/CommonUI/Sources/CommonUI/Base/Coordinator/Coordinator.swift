import UIKit

public protocol Coordinator: AnyObject {
    var router: CoordinatedNavigationController { get }

    func start()
}

open class BaseCoordinator: Coordinator {
    public var router: CoordinatedNavigationController

    public var onDestroy: (() -> Void)?

    public init(router: CoordinatedNavigationController) {
        self.router = router
        onDestroy = { [weak self] in
            guard let self = self else { return }
            self.removeChild(self)
        }
    }

    public func addChild(_ child: Coordinator) {
        router.childCoordinators.append(child)
        child.start()
    }

    public func removeChild(_ child: Coordinator) {
        let childCoordinators =  router.childCoordinators.filter { $0 !== child }
        router.childCoordinators = childCoordinators
    }

    open func start() {
        fatalError("Needs to be implemented in the subclass")
    }

    deinit {
        print("🎈 \(String(describing: self)) deinitialized.")
    }
}

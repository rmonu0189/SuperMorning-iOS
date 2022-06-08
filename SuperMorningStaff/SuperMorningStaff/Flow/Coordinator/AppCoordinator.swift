import CommonUI

class AppCoordinator: BaseCoordinator {
    override func start() {
        startGetStarted()
    }

    private func startGetStarted() {
        let coordinator = GetStartedCoordinator(router: router)
        addChild(coordinator)
    }
}

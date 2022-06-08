import UIKit

open class CoordinatedTabbarController: UITabBarController {
    public var onDestroy: (() -> ())?

    open override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .background

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }

    deinit {
        onDestroy?()
    }
}

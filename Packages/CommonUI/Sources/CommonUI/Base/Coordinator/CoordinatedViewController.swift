import UIKit

open class CoordinatedViewController: UIViewController {
    public var onDestroy: (() -> Void)?

    // MARK: - View Controller Life Cycle
    deinit {
        print("🎈 \(String(describing: self)) deinitialized.")
        onDestroy?()
    }
}

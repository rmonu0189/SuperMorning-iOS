import UIKit

extension UIView: Identifiable {}

public extension Identifiable {
    static func identifier() -> String {
        String(describing: self)
    }
}

extension UICollectionView {
    public func dequeueReusableCell<T: UICollectionViewCell>(
        withReuseIdentifier identifier: String = T.identifier(),
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue collection view cell with identifier: \(identifier)")
        }
        return cell
    }
}

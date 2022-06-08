import UIKit

public protocol Card {
    var cellType: UICollectionViewCell.Type { get set }
    func cellFor(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

open class CardItem<T: UICollectionViewCell>: Card {
    public var cellType: UICollectionViewCell.Type = T.self

    public init() {}

    open func cellFor(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: T = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

import UIKit

public class DPCollectionView: UICollectionView {
    private var localDataSource: DPCollectionViewDataSource?

    private func setDataSource(for sections: [DPSection]) {
        localDataSource = DPCollectionViewDataSource(sections: sections)
        self.dataSource = localDataSource
        self.delegate = localDataSource
    }
    
    public func refreshData(for sections: [DPSection]) {
        if let dataSource = self.dataSource as? DPCollectionViewDataSource {
            dataSource.updateSections(sections: sections)
        } else {
            setDataSource(for: sections)
        }
        self.reloadData()
    }

    public func register<T: UICollectionViewCell>(cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: cell.self))
    }
}

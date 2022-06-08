import UIKit

public struct DPPaging {
    var currentPage: Int?
    var totalPage: Int?
    var totalRecord: Int?
}

public class DPTableView: UITableView {
    private var localDataSource: DPTableViewDataSource?
    private var pullToRefreshControl: UIRefreshControl?
    
    public var loadPagingDataHandler: ((Int) -> ())?
    
    public var enablePullToRefresh: Bool = false {
        didSet {
            if enablePullToRefresh {
                pullToRefreshControl = UIRefreshControl()
                pullToRefreshControl?.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
                self.refreshControl = pullToRefreshControl
            } else {
                pullToRefreshControl?.removeTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
                self.pullToRefreshControl = nil
                self.refreshControl = nil
            }
        }
    }
    
    public var enablePaging: Bool = false {
        didSet {
            if enablePaging {
                self.prefetchDataSource = self
            } else {
                self.prefetchDataSource = nil
            }
        }
    }

    private func setDataSource(for sections: [DPSection]) {
        localDataSource = DPTableViewDataSource(sections: sections)
        self.dataSource = localDataSource
    }

    public func register<T: UITableViewCell>(cell: T.Type) {
        register(cell, forCellReuseIdentifier: String(describing: cell.self))
    }

    public func refreshData(for sections: [DPSection]) {
        if let dataSource = self.dataSource as? DPTableViewDataSource {
            dataSource.updateSections(sections: sections)
        } else {
            setDataSource(for: sections)
        }
        self.reloadData()
    }

    @objc private func pullToRefresh() {
        pullToRefreshControl?.endRefreshing()
        loadPagingDataHandler?(1)
    }
}

extension DPTableView: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let totalCells = self.numberOfRows(inSection: pagingSection)
//        let nextPageIndexPath = IndexPath(row: totalCells-1, section: pagingSection)
//        if indexPaths.contains(nextPageIndexPath) == true, self.paging?.nextPageUrl != nil {
//            pagingHandler?(self.paging?.nextPageNumber() ?? 1)
//            self.paging?.nextPageUrl = nil
//        }
    }
}

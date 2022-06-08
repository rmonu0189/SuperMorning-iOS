import UIKit
import CommonPresentation

open class BaseListViewController: BaseViewController {
    open var topInset: CGFloat { 0 }
    private var tableView: DPTableView!

    var sections: [DPSection] = [] {
        didSet {
            tableView.refreshData(for: sections)
        }
    }

    public override init(viewModel: BaseViewModelProtocol? = nil) {
        super.init(viewModel: viewModel)
        initializeUI()
        addConstraints()
        registerCell(for: tableView)
    }

    open func registerCell(for tableView: DPTableView) {}
}

extension BaseListViewController {
    private func initializeUI() {
        tableView = .init(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)
    }

    private func addConstraints() {
        tableView.pin(to: view, insets: .init(top: topInset, left: 0, bottom: 0, right: 0))
    }
}

extension BaseListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

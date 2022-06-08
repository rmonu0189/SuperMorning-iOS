import UIKit

public protocol DPTableViewCell {
    func setupUI(with item: Any)
}

public class DPSection {
    let identifier: String
    let items: [Any]
    let header: String?
    let footer: String?
    let accessoryType: UITableViewCell.AccessoryType?

    public init<T: UITableViewCell>(
        cell: T.Type,
        items: [Any],
        header: String? = nil,
        footer: String? = nil,
        accessoryType: UITableViewCell.AccessoryType? = nil
    ) {
        self.identifier = String(describing: cell.self)
        self.items = items
        self.header = header
        self.footer = footer
        self.accessoryType = accessoryType
    }

    public init<T: UICollectionViewCell>(cell: T.Type, items: [Any], header: String? = nil, footer: String? = nil) {
        self.identifier = String(describing: cell.self)
        self.items = items
        self.header = header
        self.footer = footer
        self.accessoryType = nil
    }
}

public class DPTableViewDataSource: NSObject, UITableViewDataSource {
    private var sections: [DPSection] = []

    public init(sections: [DPSection]) {
        self.sections = sections
    }

    public func updateSections(sections: [DPSection]) {
        self.sections = sections
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: section.identifier,
            for: indexPath
        )
        (cell as? DPTableViewCell)?.setupUI(with: section.items[indexPath.item])
        cell.accessoryType = section.accessoryType ?? .none
        return cell
    }

}

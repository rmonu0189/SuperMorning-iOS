import UIKit

final public class ActionSheet {
    private let items: [String]
    private let title: String?
    private var actionHandler: ((String) -> Void)?

    public init(
        items: [String],
        title: String? = nil,
        actionHandler: ((String) -> Void)? = nil
    ) {
        self.items = items
        self.title = title
        self.actionHandler = actionHandler
    }

    public func show(at controller: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for item in items {
            alert.addAction(
                .init(
                    title: item,
                    style: .default,
                    handler: { [weak self, item] _ in
                        self?.actionHandler?(item)
                    }
                )
            )
        }
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

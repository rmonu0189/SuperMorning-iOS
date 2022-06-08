import UIKit

public protocol NibView: UIView {
    static func loadFromNib() -> NibView
}

public extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

open class ViewWrapperCell<T: UIView>: UICollectionViewCell {
    public var view: T!

    override init(frame: CGRect) {
        super.init(frame: frame)
        if let nibType = T.self as? NibView.Type {
            self.view = nibType.loadFromNib() as? T
        } else {
            self.view = T(frame: frame)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

open class ViewWrapperTableCell<T: UIView>: UITableViewCell, DPTableViewCell {
    public var view: T!

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let nibType = T.self as? NibView.Type {
            self.view = nibType.loadFromNib() as? T
        } else {
            self.view = T(frame: .zero)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .none
        contentView.addSubview(view)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    public func setupUI(with item: Any) {
        (view as? BaseView)?.setupUI(with: item)
    }
}

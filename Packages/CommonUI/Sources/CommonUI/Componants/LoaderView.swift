import UIKit

public class LoaderView: UIView {
    private var activityIndicator: UIActivityIndicatorView!
    private var containerView: UIView!

    public init() {
        super.init(frame: .zero)
        initializeUI()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoaderView {
    public static func start() {
        let window = UIApplication.shared.keyWindow
        for subview in (window?.subviews ?? []) where subview is LoaderView {
            (subview as? LoaderView)?.activityIndicator.stopAnimating()
            subview.removeFromSuperview()
        }
        
        let loader = LoaderView()
        loader.frame = UIScreen.main.bounds
        loader.activityIndicator.startAnimating()
        window?.addSubview(loader)
    }

    public static func stop() {
        let window = UIApplication.shared.keyWindow
        for subview in (window?.subviews ?? []) where subview is LoaderView {
            (subview as? LoaderView)?.activityIndicator.stopAnimating()
            subview.removeFromSuperview()
        }
    }
}

extension LoaderView {
    private func initializeUI() {
        backgroundColor = .black.withAlphaComponent(0.6)

        containerView = .init(frame: .zero)
        containerView.backgroundColor = .white
        containerView.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        activityIndicator = .init(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 80),
            containerView.widthAnchor.constraint(equalToConstant: 80),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

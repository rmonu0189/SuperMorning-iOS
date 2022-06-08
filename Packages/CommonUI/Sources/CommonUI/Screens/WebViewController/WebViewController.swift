import UIKit
import WebKit

public class WebViewController: BaseViewController, WebViewActionable {
    private var headerView: HeaderView!
    private var webView: WKWebView!
    private let webTitle: String
    private let url: String

    public var onBackAction: (() -> Void)?

    public init(webTitle: String, url: String) {
        self.webTitle = webTitle
        self.url = url
        super.init()
        initializeUI()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let webUrl = URL(string: url) else { return }
        webView.load(.init(url: webUrl))
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        headerView.stopLoading()
    }
}

extension WebViewController {
    private func initializeUI() {
        headerView = .init(
            uiModel: .init(title: webTitle, imageName: ""),
            backButtonHandler: { [weak self] in
                self?.onBackAction?()
            }
        )
        headerView.isLarge = false
        headerView.startLoading()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        webView = .init(frame: .zero)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
